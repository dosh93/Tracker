//
//  SheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Dosh on 03.04.2024.
//

import Foundation

protocol SheduleViewControllerDelegate: AnyObject {
    func addShedule(_ shedule: [Weekday])
}
