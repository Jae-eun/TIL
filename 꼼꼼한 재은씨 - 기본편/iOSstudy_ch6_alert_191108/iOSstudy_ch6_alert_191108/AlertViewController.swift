//
//  AlertViewController.swift
//  iOSstudy_ch6_alert_191108
//
//  Created by 이재은 on 03/12/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import UserNotifications

class AlertViewController: UIViewController {

    @IBOutlet weak var msg: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func save(_ sender: Any) {
        if #available(iOS 10, *) {
            // 알림 동의 여부 확인
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        // 알림 콘텐츠 정의
                        let nContent = UNMutableNotificationContent()
                        nContent.body = (self.msg.text)!
                        nContent.title = "미리 알림"
                        nContent.sound = UNNotificationSound.default

                        // 발송 시각을 지금으로부터 *초 후인지 계산해서 반환
                        let time = self.datePicker.date.timeIntervalSinceNow
                        // 발송 조건 정의
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,
                                                                        repeats: false)
                        // 발송 요청 객체 정의
                        let request = UNNotificationRequest(identifier: "alarm",
                                                            content: nContent,
                                                            trigger: trigger)
                        // 노티피케이션 센터에 추가
                        UNUserNotificationCenter.current().add(request) { (_) in
                            DispatchQueue.main.async {
                                // 발송 완료 안내 메시지 창
                                let date = self.datePicker.date.addingTimeInterval(9*60*60)
                                let message = "알림이 등록되었습니다. 등록된 알림은 \(date)에 발송됩니다"
                                let alert = UIAlertController(title: "알림 등록",
                                                              message: message,
                                                              preferredStyle: .alert)
                                let ok = UIAlertAction(title: "확인", style: .default)
                                alert.addAction(ok)

                                self.present(alert, animated: false)
                            }
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "알림 등록",
                                                  message: "알림이 허용되어 있지 않습니다",
                                                  preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)

                    self.present(alert, animated: false)
                    return
                }
            }
        } else {
            UIApplication.shared
                .registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            let notification = UILocalNotification()
            notification.userInfo = ["indentifier" : "noti"]
            notification.alertTitle = "Notification"
            notification.alertBody = "Body"
            notification.fireDate = NSDate(timeIntervalSinceNow:60) as Date
            notification.repeatInterval = NSCalendar.Unit.minute
            //            UIApplication.shared.cancelAllLocalNotifications()
            UIApplication.shared.scheduledLocalNotifications = [notification]

        }
    }

}
