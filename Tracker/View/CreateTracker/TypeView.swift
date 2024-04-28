//
//  SettingActionView.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import Foundation

struct SettingActionView {
    let header: String
    let tableCount: Int
    let type: TypeView
    var tracker: Tracker? = nil
    var countCompleted: Int? = nil
    var category: String? = nil
}

enum TypeView {
    case regular
    case unregular
}
