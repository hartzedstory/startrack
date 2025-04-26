//
//  AppDelegate.swift
//  StartTrack
//
//  Created by Hartzed Story on 12/3/25.
//

import UIKit
import AlamofireNetworkActivityLogger
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApplication(application: application)
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        return true
    }
    
    func startApplication(application: UIApplication) {
    }
}

