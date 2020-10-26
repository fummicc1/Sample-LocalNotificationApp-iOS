//
//  AddNotificationViewController.swift
//  LocalNotificationApp
//
//  Created by Fumiya Tanaka on 2020/10/26.
//

import UIKit
import UserNotifications

class AddNotificationViewController: UIViewController {

    @IBOutlet var addNotificationButton: UIButton!
    @IBOutlet var notificationDatePicker: UIDatePicker!
    @IBOutlet var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UIデザイン
        // addNotificationButtonを角丸にする
        addNotificationButton.layer.cornerRadius = 8
        // addNotificationButtonに枠線をつける
        addNotificationButton.layer.borderWidth = 1
        addNotificationButton.layer.borderColor = UIColor.systemBlue.cgColor
    }

    // MARK: @IBAction
    // addNotificationメソッド: 通知を追加するボタンが押された時に呼ばれる
    @IBAction func addNotification() {
        // DatePickerから日付を取得
        let notificationDate: Date = notificationDatePicker.date
        // テキストフィールドからテキストを取得
        let notificationTitle: String = titleTextField.text!
        // MARK: 通知をいつ発動するかを設定
        // カレンダークラスを作成
        let calendar = Calendar.current
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents(in: .current, from: notificationDate), repeats: false)
        // MARK: 通知の中身を設定
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.badge = 1
        // MARK: 通知のリクエストを作成
        let request = UNNotificationRequest(
            identifier: "Notification: \(notificationTitle)", content: content, trigger: trigger)
        
        // MARK: 通知のリクエストを実際に登録する
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            // エラーが存在しているかをif文で確認している
            if error != nil {
                // MARK: エラーが存在しているので、エラー内容をprintする
                print(error)
            } else {
                // MARK: エラーがないので、うまく通知を追加できた
                // 前のCalendar画面に戻る
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

