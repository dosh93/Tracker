//
//  CreateTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Dosh on 02.04.2024.
//

import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, _ category: String)
}
