//
//  Weekday.swift
//  Tracker
//
//  Created by Dosh on 31.03.2024.
//

import Foundation

enum Weekday: String, CaseIterable {
    case mon, tue, wed, thu, fri, sat, sun
}

extension Weekday {
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    var getDayNumber: Int {
        switch self {
        case .mon: return 2
        case .tue: return 3
        case .wed: return 4
        case .thu: return 5
        case .fri: return 6
        case .sat: return 7
        case .sun: return 1
        }
    }
    
    var getShortDayName: String {
        return NSLocalizedString("\(self.rawValue)Short", comment: "")
    }
}
