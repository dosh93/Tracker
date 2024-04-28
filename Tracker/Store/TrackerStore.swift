//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    private var context: NSManagedObjectContext {
        return MainStore.persistentContainer.viewContext
    }
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.isPinned, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.name, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "category.name", cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        return controller
    }()
    
    private lazy var pinnedfetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        return controller
    }()
    
    var isEmpty: Bool {
        fetchedResultsController.sections?.isEmpty ?? true
    }
    
    private var pinnedTrackers: [Tracker]? {
        guard
            let trackersCD = pinnedfetchedResultsController.fetchedObjects
        else { return nil}
        
        return trackersCD.compactMap({ convert(trackerCD: $0) })
    }
    
    var numberOfSections: Int {
        let numberOfSections = fetchedResultsController.sections?.count ?? 0
        
        if !isEmptyPin() {
            return numberOfSections + 1
        }
        
        return numberOfSections
    }
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let convertor = Convertor()
    
    init(delegate: StoreDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetchTracker(by id: UUID) throws -> TrackerCoreData? {
        do {
            let request = TrackerCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), id as CVarArg)
            request.fetchLimit = 1
            guard let tracker = try context.fetch(request).first else {
                return nil
            }
            return tracker
        } catch {
            throw TrackerError.fetchTrackerError
        }
    }
    
    func saveTracker(tracker: Tracker, fromCategory: String) throws {
        let categoryCD: TrackerCategoryCoreData
        
        do {
            if let category = try trackerCategoryStore.fetchTrackerCategory(by: fromCategory) {
                categoryCD = category
            } else {
                categoryCD = try trackerCategoryStore.createCategory(name: fromCategory)
            }
        } catch {
            throw error
        }
        
        let trackerCD: TrackerCoreData
        do {
            if let existingTracker = try fetchTracker(by: tracker.id) {
                trackerCD = existingTracker
            } else {
                trackerCD = TrackerCoreData(context: context)
            }
            trackerCD.trackerId = tracker.id
            trackerCD.name = tracker.name
            trackerCD.color = tracker.color.toHexString()
            trackerCD.emoji = tracker.emoji
            trackerCD.isRegular = tracker.isRegular
            trackerCD.category = categoryCD
            trackerCD.schedule = convertor.scheduleToCoreData(schedule: tracker.schedule)
            trackerCD.isPinned = tracker.isPinned
            try context.save()
        } catch TrackerError.fetchTrackerError {
            throw TrackerError.fetchTrackerError
        } catch {
            throw TrackerError.saveTrackerError
        }
    }
    
    func filter(weekday: Weekday, searchText: String, date: Date, isCompleted: Bool?) {
        var predicates: [NSPredicate] = []

        predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), weekday.rawValue))

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), searchText))
        }

        func createConditionPredicate(forDate date: Date) -> NSCompoundPredicate {
            let datePredicate = NSPredicate(format: "SUBQUERY(records, $record, $record.date == %@).@count > 0", date as CVarArg)
            let noRecordsPredicate = NSPredicate(format: "records.@count == 0")
            let recordsOrNoRecordsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [datePredicate, noRecordsPredicate])
            
            let regularPredicate = NSPredicate(format: "isRegular == YES")
            let irregularPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "isRegular == NO"),
                recordsOrNoRecordsPredicate
            ])
            
            return NSCompoundPredicate(orPredicateWithSubpredicates: [regularPredicate, irregularPredicate])
        }

        if let isCompleted = isCompleted {
            if isCompleted {
                predicates.append(NSPredicate(format: "SUBQUERY(records, $record, $record.date == %@).@count > 0", date as CVarArg))
            } else {
                predicates.append(NSPredicate(format: "SUBQUERY(records, $record, $record.date == %@).@count == 0", date as CVarArg))
                predicates.append(createConditionPredicate(forDate: date))
            }
        } else {
            predicates.append(createConditionPredicate(forDate: date))
        }

        var predicatesForPin = predicates
        predicatesForPin.append(NSPredicate(format: "isPinned == YES"))
        pinnedfetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicatesForPin)
        
        predicates.append(NSPredicate(format: "isPinned != YES"))
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            try fetchedResultsController.performFetch()
            try pinnedfetchedResultsController.performFetch()
            delegate?.didUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        var currentSection = section
        if (!isEmptyPin() && section == 0) {
            return pinnedfetchedResultsController.sections?[currentSection].numberOfObjects ?? 0
        }
        
        if !isEmptyPin() {
            currentSection = currentSection - 1
        }
        
        return fetchedResultsController.sections?[currentSection].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        return convert(trackerCD: objectCd(at: indexPath))
    }
    
    func objectCd(at indexPath: IndexPath) -> TrackerCoreData {
        if !isEmptyPin() {
            if indexPath.section == 0 {
                return pinnedfetchedResultsController.object(at: indexPath)
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                return fetchedResultsController.object(at: newIndexPath)
            }
        }
        
        return fetchedResultsController.object(at: indexPath)
    }
    
    func header(at indexPath: IndexPath) -> String? {
        var section = indexPath.section
        if (!isEmptyPin() && indexPath.section == 0) {
            return NSLocalizedString("category.pid", comment: "Категория закрепленных")
        }
        if !isEmptyPin() {
            section = section - 1
        }
        
        return fetchedResultsController.sections?[section].name
    }
    
    func category(at indexPath: IndexPath) -> String {
        objectCd(at: indexPath).category?.name ?? ""
    }
    
    func convert(trackerCD: TrackerCoreData) -> Tracker {
        return Tracker(
            id: trackerCD.trackerId ?? UUID(),
            name: trackerCD.name ?? "",
            color: UIColor(hexString: trackerCD.color!) ?? .ypColor1,
            emoji: trackerCD.emoji ?? "",
            schedule: convertor.scheduleFromCoreData(schedule: trackerCD.schedule),
            isRegular: trackerCD.isRegular,
            isPinned: trackerCD.isPinned
        )
    }
    
    func delete(_ indexPath: IndexPath) {
        let trackerCD = fetchedResultsController.object(at: indexPath)
        trackerCD.records?.forEach { context.delete($0 as? NSManagedObject ?? NSManagedObject()) }
        context.delete(trackerCD)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func changePinTracker(_ indexPath: IndexPath) {
        if !isEmptyPin() {
            if indexPath.section == 0 {
                let pinnedTracker = pinnedfetchedResultsController.object(at: indexPath)
                pinnedTracker.isPinned.toggle()
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                let trackerCD = fetchedResultsController.object(at: newIndexPath)
                trackerCD.isPinned.toggle()
            }
        } else {
            let trackerCD = fetchedResultsController.object(at: indexPath)
            trackerCD.isPinned.toggle()
        }
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func isPinned(at indexPath: IndexPath) -> Bool {
        object(at: indexPath)?.isPinned ?? false
    }
    
    func isEmptyPin() -> Bool {
        pinnedTrackers?.isEmpty ?? true
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
