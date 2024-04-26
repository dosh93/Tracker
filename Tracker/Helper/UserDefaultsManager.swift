//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Dosh on 17.04.2024.
//

import Foundation

class UserDefaultsManager {
    private let hasOnboardedKey = "hasOnboarded"

    static let shared = UserDefaultsManager()

    private init() {}

    func hasOnboarded() -> Bool {
        return UserDefaults.standard.bool(forKey: hasOnboardedKey)
    }

    func setOnboarded() {
        UserDefaults.standard.set(true, forKey: hasOnboardedKey)
        UserDefaults.standard.synchronize()
    }
}

