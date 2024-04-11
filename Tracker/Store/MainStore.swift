//
//  MainStore.swift
//  Tracker
//
//  Created by Dosh on 08.04.2024.
//

import CoreData
import UIKit

class MainStore {
    internal let context: NSManagedObjectContext
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Not found AppDelegate")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
}
