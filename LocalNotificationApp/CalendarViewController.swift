//
//  CalendarViewController.swift
//  LocalNotificationApp
//
//  Created by Fumiya Tanaka on 2020/10/26.
//

import UIKit
// FSCalendarを使用するためにimportする
import FSCalendar
// UNNotificationを使用するためにimportする
import UserNotifications

class CalendarViewController: UIViewController, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var fsCalendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    
    var notificationRequests: [UNNotificationRequest] = []
    
    // MARK: viewDidLoad ... 初めてviewが読み込まれた際に実行される（一度しか実行されない）
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: FSCalendarを選択できないようにする
        fsCalendar.allowsSelection = false
        // MARK: デリゲートの指定
        fsCalendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: viewWillAppear ... このViewControllerが表示される直前に実行される（何度でも実行される）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: まだ完了していない通知を取得する
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            // MARK: まだ完了していない通知の取得が完了したら、ここのブロックが実行される
            // DispatchQueue.main.async {} に関しては今は分からなくても大丈夫
            DispatchQueue.main.async {
                print(requests)
                // 通知リクエストの配列を更新する
                self.notificationRequests = requests
                // カレンダーをリロードする
                self.fsCalendar.reloadData()
                // テーブルビューをリロードする
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: 一つ一つのcell（セル）の日付に対して、イベントの数を設定する
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // for文から見つけてきた表示するセルと同じ日付の通知リクエストの数を数える
        var numberOfNotifications: Int = 0
        // MARK: for文を使用して一つ一つの通知と、表示するセルの日付が同じを比較する
        for request in notificationRequests {
            // requestからtrigger（いつ通知を発火するかを管理するもの）を取り出す
            let trigger = request.trigger as! UNCalendarNotificationTrigger
            // trigger.nextTriggerDate()で次に通知が発火される日付を取得できる
            let nextDate = trigger.nextTriggerDate()!
            // 日付を比較するためにCalendarクラスを用意
            let calendar = Calendar.current
            // 同じ日であるかを比較する
            let isSameDay = calendar.isDate(nextDate, inSameDayAs: date)
            // if文で同じ日であるかをif文で確認する
            if isSameDay {
                // 表示したいセルの日付と一致したので、上で用意したnumberOfNotificationsを1増やす
                numberOfNotifications += 1
            }
        }
        return numberOfNotifications
    }
    
    // MARK: 一つ一つのcell（セル）に対して、データを代入したり、色を変更したりすることで、セルのデータを個々に変えることができる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの位置に対応する通知のリクエストを取得
        let request = notificationRequests[indexPath.row]
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        // セルにデータを代入していく
        cell.textLabel?.text = request.content.title
        // requestからtrigger（いつ通知を発火するかを管理するもの）を取り出す
        let trigger = request.trigger as! UNCalendarNotificationTrigger
        // trigger.nextTriggerDate()で次に通知が発火される日付を取得できる
        let nextDate = trigger.nextTriggerDate()
        if nextDate == nil {
            return cell
        }
        // 日付をテキストに変換するためにDateFormatterを使用
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: nextDate!)
        return cell
    }
    
    // MARK: TableViewに表示するセルの個数を決めることができる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // また完了していない通知の数だけセルを用意するようにしている
        return notificationRequests.count
    }
}
