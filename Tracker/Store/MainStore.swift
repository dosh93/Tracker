//
//  MainStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

class MainStore {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tacker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
            }
        })
        return container
    }()
}
