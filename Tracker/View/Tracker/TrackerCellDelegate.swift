//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Dosh on 31.03.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func trackerCompleted(for id: UUID, at indexPath: IndexPath)
}
