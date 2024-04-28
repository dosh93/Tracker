//
//  Date.swift
//  Tracker
//
//  Created by Dosh on 11.04.2024.
//

import Foundation

extension Date {
    var normalized: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}
