//
//  AddNotificationViewController.swift
//  LocalNotificationApp
//
//  Created by Fumiya Tanaka on 2020/10/26.
//

import UIKit
import UserNotifications

class AddNotificationViewController: UIViewController {

    // MARK: @IBOutlet
    // 通知を追加する際に押すボタンと関連づける
    @IBOutlet var addNotificationButton: UIButton!
    // 通知を白化させる日付を選択するDatePickerと関連づける
    @IBOutlet var notificationDatePicker: UIDatePicker!
    // 通知に表示するテキストを入力するためのテキストフィールドと関連づける
    @IBOutlet var titleTextField: UITextField!
    // 追加画面を閉じてカレンダー画面に戻ることができるボタンと関連づける
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: UIデザイン
        // backButtonを角丸にする
        backButton.layer.cornerRadius = 8
        // addNotificationButtonを角丸にする
        addNotificationButton.layer.cornerRadius = 8
        // addNotificationButtonに枠線をつける（borderWidth ... 線の太さ） (borderColor ... 線の色)
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
        let calendar: Calendar = Calendar.current
        let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), repeats: false)
        // MARK: 通知の中身を設定
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = notificationTitle
        content.sound = UNNotificationSound.default
        content.badge = 1
        // MARK: 通知のリクエストを作成
        let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
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
    
    // backメソッド: バツボタンを押した際に呼ばれる
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}

