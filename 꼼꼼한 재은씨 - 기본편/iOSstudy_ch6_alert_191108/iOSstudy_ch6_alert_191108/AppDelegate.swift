//
//  AppDelegate.swift
//  iOSstudy_ch6_alert_191108
//
//  Created by 이재은 on 08/11/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == "wakeup" {
            let userInfo = notification.request.content.userInfo
            print(userInfo["name"]!)
        }
        completionHandler([.alert, .badge, .sound])
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "wakeup" {
            let userInfo = response.notification.request.content.userInfo
            print(userInfo["name"]!)
        }
        completionHandler()
    }
    // 앱이 처음 실행될 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 11.0, *) {
            let notiCenter = UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in
            }
            notiCenter.delegate = self
        } else {
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
            if let localNoti = launchOptions?[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
                print((localNoti.userInfo?["name"])!)
            }
        }
        return true
    }

    // 앱이 활성화를 잃었을 때
    func applicationWillResignActive(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                    let nContent = UNMutableNotificationContent()
                    nContent.badge = 1
                    nContent.title = "로컬 알림 메시지"
                    nContent.subtitle = "준비된 내용이 아주 많아요!"
                    nContent.body = "앗! 다시 들어오세요!"
                    nContent.sound = UNNotificationSound.default
                    nContent.userInfo = ["name": "홍길동"]

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                } else {
                    print("사용자가 동의하지 않음")
                    let setting = application.currentUserNotificationSettings
                    guard setting?.types != .none else { // 허용 안하면
                        print("Can't Schedule")
                        return
                    }
                }
            }
        } else {
            let noti = UILocalNotification()
            noti.fireDate = Date(timeIntervalSinceNow: 10)
            noti.timeZone = TimeZone.autoupdatingCurrent
            noti.alertBody = "다시 접속하세요!"
            noti.alertAction = "학습하기"
            noti.applicationIconBadgeNumber = 1
            noti.soundName = UILocalNotificationDefaultSoundName
            noti.userInfo = ["name": "이재은"]

            application.scheduleLocalNotification(noti)
        }
    }

    // 앱이 실행중인 상태에서 알림이 도착한다면
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print((notification.userInfo?["name"])!)
        if application.applicationState == UIApplication.State.active {
            // 앱이 활성화 된 상태일 때 실행할 로직
            print("앱이 실행중태이며 활성 상태에 알림이 도착했어요")
        } else if application.applicationState == .inactive {
            // 앱이 비활성화된 상태일 때 실행할 로직
            print("앱이 실행중인데 비활성 상태에 알림이 도착했어요")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

