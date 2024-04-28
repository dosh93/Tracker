//
//  AppDelegate.swift
//  Tracker
//
//  Created by Dosh on 09.03.2024.
//

import UIKit
import AppMetricaCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Analysis.setup()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func createMainAppViewController() -> UIViewController {
        let trackerVC = TrackerViewController()
        let statisticsVC = StatisticsViewController()
        trackerVC.delegate = statisticsVC

        let trackerImage = UIImage(named: "Tracker")
        let statisticsImage = UIImage(named: "Stats")

        trackerVC.tabBarItem = UITabBarItem(title: NSLocalizedString("label.tracker", comment: "Трекеры"), image: trackerImage, tag: 0)
        statisticsVC.tabBarItem = UITabBarItem(title: NSLocalizedString("label.statistic", comment: "Статистика"), image: statisticsImage, tag: 1)

        let trackerNavController = UINavigationController(rootViewController: trackerVC)
        let statisticsNavController = UINavigationController(rootViewController: statisticsVC)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerNavController, statisticsNavController]
        tabBarController.tabBar.tintColor = .ypBlue
        tabBarController.tabBar.backgroundColor = .ypWhite
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBarController.tabBar.frame.width, height: 1))
        topLine.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        tabBarController.tabBar.addSubview(topLine)

        return tabBarController
    }

}

