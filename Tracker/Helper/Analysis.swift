//
//  Analysis.swift
//  Tracker
//
//  Created by Dosh on 27.04.2024.
//

import Foundation
import AppMetricaCore

final class Analysis {
    static func setup() {
        guard let configuration = AppMetricaConfiguration(apiKey: "7ad1aa54-da7f-4837-9040-dc52006c2dc9") else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    static func report(event: Event, screen: Screen, item: Item? = nil) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if event == .click, let item {
            params["item"] = item.rawValue
        }
        
        AppMetrica.reportEvent(name: event.rawValue, parameters: params) { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}

enum Event: String {
    case open
    case close
    case click
}

enum Screen: String {
    case main = "Main"
}

enum Item: String {
    case addTracker = "add_tracker"
    case track
    case filter
    case edit
    case delete
}

