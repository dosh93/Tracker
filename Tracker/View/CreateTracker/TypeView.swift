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
}

enum TypeView {
    case regular
    case unregular
}
