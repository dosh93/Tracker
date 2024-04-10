//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData

final class TrackerRecordStore: MainStore {
    
    private let trackerStore = TrackerStore()
    
    func saveTrackerRecord(record: TrackerRecord) throws {
        let recordCD = TrackerRecordCoreData(context: context)
        recordCD.trackerId = record.trackerId
        recordCD.date = record.date
        do {
            recordCD.tracker = try trackerStore.fetchTracker(by: record.trackerId)
            try context.save()
        } catch TrackerError.fetchTrackerError {
            throw TrackerError.fetchTrackerError
        } catch {
            throw TrackerRecordError.saveTrackerRecordError
        }
    }
    
    func fetchTrackerRecords() throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return results.map { recordCD in
                TrackerRecord(trackerId: recordCD.trackerId!, date: recordCD.date!)
            }
        } catch {
            throw TrackerRecordError.fetchTrackerRecordError
        }
    }
    
    func fetchTrackerRecord(by trackerRecord: TrackerRecord) throws -> TrackerRecordCoreData {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let predict = NSPredicate(format: "%K == %@ and %K == %@", #keyPath(TrackerRecordCoreData.trackerId), trackerRecord.trackerId as CVarArg, #keyPath(TrackerRecordCoreData.date), trackerRecord.date as CVarArg)
        request.predicate = predict
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request).first
            return result!
        } catch {
            throw TrackerRecordError.fetchTrackerRecordError
        }
    }
    
    func deleteTrackerRecord(by trackerRecord: TrackerRecord) throws {
        do {
            context.delete(try fetchTrackerRecord(by: trackerRecord))
        } catch {
            throw TrackerRecordError.deleteTrackerRecordError
        }
    }
}

