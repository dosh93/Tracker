//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    
    private var context: NSManagedObjectContext {
        return MainStore.persistentContainer.viewContext
    }
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: #keyPath(TrackerRecordCoreData.trackerId), cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        return controller
    }()
    
    private let trackerStore = TrackerStore()
    
    init(delegate: StoreDelegate? = nil) {
        self.delegate = delegate
    }
    
    func countCompleted(at trackedId: UUID) -> Int {
        fetchedResultsController.sections?.first {$0.name == trackedId.uuidString}?.numberOfObjects ?? 0
    }
    
    func objects(at trackedId: UUID) -> [TrackerRecord] {
        return convert(objectsCD(at: trackedId))
    }
    
    private func objectsCD(at trackedId: UUID) -> [TrackerRecordCoreData] {
        guard let treackerRecordsCD = fetchedResultsController.sections?.first(where: { $0.name == trackedId.uuidString })?.objects as? [TrackerRecordCoreData] else {
            return []
        }
        return treackerRecordsCD
    }
    
    func completed(at trackedId: UUID, date: Date) {
        do {
            guard let trackerRecordCD = isCompleted(at: trackedId, date: date) else {
                try saveTrackerRecord(record: TrackerRecord(trackerId: trackedId, date: date))
                return
            }
            try deleteTrackerRecord(by: trackerRecordCD)
        } catch {
            print("Faild completed")
        }
    }
    
    func isCompleted(at trackedId: UUID, date: Date) -> TrackerRecordCoreData? {
        let trackerRecordsCD = objectsCD(at: trackedId)
        guard let trackerRecordCD = trackerRecordsCD.first(where: { $0.date == date}) else {
            return nil
        }
        return trackerRecordCD
    }
    
    private func convert(_ treackerRecordsCD: [TrackerRecordCoreData]) -> [TrackerRecord] {
        return treackerRecordsCD.map {TrackerRecord(trackerId: $0.trackerId ?? UUID(), date: $0.date ?? Date())}
    }
    
    func saveTrackerRecord(record: TrackerRecord) throws {
        let recordCD = TrackerRecordCoreData(context: context)
        recordCD.trackerId = record.trackerId
        recordCD.date = record.date.normalized
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
    
    func deleteTrackerRecord(by trackerRecord: TrackerRecordCoreData?) throws {
        if let trackerRecord {
            context.delete(trackerRecord)
            do {
                try context.save()
            } catch {
                print("faild deleteTrackerRecord")
            }
            
        }
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
