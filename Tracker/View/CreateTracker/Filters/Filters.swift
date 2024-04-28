//
//  Filters.swift
//  Tracker
//
//  Created by Dosh on 27.04.2024.
//

import Foundation

enum Filters: String, CaseIterable {
    case all, today, completed, notCompleted
}

extension Filters {
    var localizedName: String {
        return NSLocalizedString("filter.\(self.rawValue)", comment: "")
    }
}
