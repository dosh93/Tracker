//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: MainStore {
    
    private let convertor = Convertor()
    
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
        } catch CategoryStoreError.fetchCategoryError {
            throw CategoryStoreError.fetchCategoryError
        } catch {
            throw CategoryStoreError.createCategoryError
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
            throw CategoryStoreError.fetchCategoryError
        }
    }
    
    func fetchTrackerCategories() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return try results.map { categoryCD in
                TrackerCategory(
                    title: categoryCD.name!,
                    trackers: try (categoryCD.trackers as? Set<TrackerCoreData> ?? []).map { trackerCD in
                        Tracker(
                            id: trackerCD.trackerId!,
                            name: trackerCD.name!,
                            color: UIColor(hexString: trackerCD.color!)!,
                            emoji: trackerCD.emoji!,
                            schedule: try convertor.scheduleFromCoreData(schedule: trackerCD.schedule!),
                            isRegular: trackerCD.isRegular
                        )
                    }
                )
            }
        } catch ConvertorError.convertColorFromCoreDataError {
            throw ConvertorError.convertColorFromCoreDataError
        } catch ConvertorError.convertWeekdayFromCoreDataError {
            throw ConvertorError.convertWeekdayFromCoreDataError
        } catch {
            throw CategoryStoreError.fetchCategoryError
        }
    }
    
}
