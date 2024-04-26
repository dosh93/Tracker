//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Dosh on 24.04.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackerViewControllerLightMode() {
        let vc = TrackerViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        vc.overrideUserInterfaceStyle = .light
        vc.view.layoutIfNeeded()
        assertSnapshot(matching: vc, as: .image)
    }

    func testTrackerViewControllerDarkMode() {
        let vc = TrackerViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        vc.overrideUserInterfaceStyle = .dark
        vc.view.layoutIfNeeded()
        assertSnapshot(matching: vc, as: .image)
    }

}
