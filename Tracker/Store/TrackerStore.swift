//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData

final class TrackerStore: MainStore {
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let convertor = Convertor()
    
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
    
    func saveTracker(tracker: Tracker, fromCategory: String) throws -> TrackerCoreData {
        let categoryCD: TrackerCategoryCoreData
        
        do {
            if let category = try trackerCategoryStore.fetchTrackerCategory(by: fromCategory) {
                categoryCD = category
            } else {
                categoryCD = try trackerCategoryStore.createCategory(name: fromCategory)
            }
        } catch CategoryStoreError.fetchCategoryError {
            throw CategoryStoreError.fetchCategoryError
        } catch CategoryStoreError.createCategoryError {
            throw CategoryStoreError.createCategoryError
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
            return trackerCD
        } catch TrackerError.fetchTrackerError {
            throw TrackerError.fetchTrackerError
        } catch {
            throw TrackerError.saveTrackerError
        }
    }
    
}
