//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    private let convertor = Convertor()
    private weak var delegate: StoreDelegate?
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Not found AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.objectID, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        return controller
    }()
    
    init(delegate: StoreDelegate? = nil) {
        self.delegate = delegate

    }
    
    func createCategory(name: String) throws -> TrackerCategoryCoreData {
        do {
            let categoryCD: TrackerCategoryCoreData
            if let existingCategory = try fetchTrackerCategory(by: name) {
                categoryCD = existingCategory
            } else {
                categoryCD = TrackerCategoryCoreData(context: context)
                categoryCD.name = name
            }
            try context.save()
            return categoryCD
        } catch {
            throw error
        }
    }
    
    func fetchTrackerCategory(by name: String) throws -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
        request.fetchLimit = 1
        do {
            let existingCategories = try context.fetch(request)
            guard let category = existingCategories.first else { return nil }
            return category
        } catch {
            throw error
        }
    }
    
    func fetchTrackerCategories() throws -> [TrackerCategory] {
        guard let results = fetchResultsController.fetchedObjects else { return [] }
        return results.map { categoryCD in
            TrackerCategory(
                title: categoryCD.name ?? "",
                trackers: (categoryCD.trackers as? Set<TrackerCoreData> ?? []).map { trackerCD in
                    Tracker(
                        id: trackerCD.trackerId ?? UUID(),
                        name: trackerCD.name ?? "",
                        color: UIColor(hexString: trackerCD.color!) ?? .ypColor1,
                        emoji: trackerCD.emoji ?? "",
                        schedule: convertor.scheduleFromCoreData(schedule: trackerCD.schedule),
                        isRegular: trackerCD.isRegular
                    )
                }
            )
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
