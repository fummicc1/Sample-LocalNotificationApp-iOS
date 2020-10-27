//
//  AppDelegate.swift
//  LocalNotificationApp
//
//  Created by Fumiya Tanaka on 2020/10/26.
//

import UIKit
import UserNotifications

// MARK: UNUserNotificationCenterDelegateに準拠する
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: 通知の許可をリクエストする
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
            print("許可されたか: \(granted)")
        }
        // MARK: UNUserNotificationCenterDelegateを指定する
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: UNUserNotificationDelegateを実装する
    // フォアグラウンドで通知を受け取った際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(
            [
                UNNotificationPresentationOptions.banner,
                UNNotificationPresentationOptions.list,
                UNNotificationPresentationOptions.sound,
                UNNotificationPresentationOptions.badge
            ]
        )
    }
    
    // バックグランドで通知を受け取った際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

