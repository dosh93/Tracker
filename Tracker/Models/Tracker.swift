//
//  Tracker.swift
//  Tracker
//
//  Created by Dosh on 10.03.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let isRegular: Bool
}
