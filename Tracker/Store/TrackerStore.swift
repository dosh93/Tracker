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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Not found AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
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
        } catch TrackerError.fetchTrackerError {
            throw TrackerError.fetchTrackerError
        } catch {
            throw TrackerError.saveTrackerError
        }
    }
    
    func filter(weekday: Weekday, searchText: String, date: Date) {
        var predicts: [NSPredicate] = []
        
        if !searchText.isEmpty {
            predicts.append(NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), searchText))
        }
        
        predicts.append(NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.schedule), weekday.rawValue))
        
        let regularPredicate = NSPredicate(format: "isRegular == YES")

        let datePredicate = NSPredicate(format: "SUBQUERY(records, $record, $record.date == %@).@count > 0", date as CVarArg)
        let noRecordsPredicate = NSPredicate(format: "records.@count == 0")
        let recordsOrNoRecordsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [datePredicate, noRecordsPredicate])
        let irregularWithConditionPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isRegular == NO"),
            recordsOrNoRecordsPredicate
        ])

        let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [regularPredicate, irregularWithConditionPredicate])

        predicts.append(combinedPredicate)

        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicts)
        
        do {
            try fetchedResultsController.performFetch()
            delegate?.didUpdate()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var isEmpty: Bool {
        fetchedResultsController.sections?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCD = fetchedResultsController.object(at: indexPath)
        return convert(trackerCD: trackerCD)
    }
    
    func header(at indexPath: IndexPath) -> String? {
        fetchedResultsController.sections?[indexPath.section].name
    }
    
    func convert(trackerCD: TrackerCoreData) -> Tracker {
        return Tracker(
            id: trackerCD.trackerId ?? UUID(),
            name: trackerCD.name ?? "",
            color: UIColor(hexString: trackerCD.color!) ?? .ypColor1,
            emoji: trackerCD.emoji ?? "",
            schedule: convertor.scheduleFromCoreData(schedule: trackerCD.schedule),
            isRegular: trackerCD.isRegular
        )
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
