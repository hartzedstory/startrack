//
//  AppDelegate.swift
//  StartTrack
//
//  Created by Hartzed Story on 12/3/25.
//

import UIKit
import UserNotifications
import AlamofireNetworkActivityLogger
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseAppCheck
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var appCheckProviderFactory:AppCheckProvider?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startApplication(application: application)
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
        //Setup Firebase
        let providerFactory = AppAttestProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        Analytics.setAnalyticsCollectionEnabled(true)
        
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound,]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        if FCMTokenManager.savedToken == nil {
            Messaging.messaging().token { token, error in
                if let token = token {
                    print("Lấy FCM token mới: \(token)")
                    FCMTokenManager.save(token: token)
                    // Gửi token lên server nếu cần
                } else if let error = error {
                    print("❌ Lỗi khi lấy FCM token: \(error.localizedDescription)")
                }
            }
        } else {
            print("Token đã tồn tại: \(FCMTokenManager.savedToken!)")
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.vn.imagination.fusionwork.refresh", using: nil) { task in
            // Xử lý background task ở đây
            task.setTaskCompleted(success: true)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("📱 APNs Token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        let userInfo = response.notification.request.content.userInfo
//
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil)
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
    
    
    func startApplication(application: UIApplication) {
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("Firebase registration token: \(String(describing: token))")
        if token != FCMTokenManager.savedToken {
            FCMTokenManager.save(token: token)
        }
    }
}
