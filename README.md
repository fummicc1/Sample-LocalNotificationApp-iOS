# [iOS Swift] ローカル通知をやってみる

## はじめに

この記事では iOS アプリでプッシュ通知について説明します。

## これから学ぶ知識

- 通知
- AppDelegate
- UNUserNotificationCenter
- FSCalendar

## 通知とは

### 概要

スマートフォンを使っていると 1 日に 1 度はみることのある**通知**は、**ユーザーがアプリを開いていなくてもアプリに関する情報を伝えられる**というメリットが強力です。

例えば、アラームアプリはユーザーがアプリを開いていなくてもその時刻が来たことを適切に伝えてくれます。

また、通知にはいくつかの種類がありますが、よく使われるのは以下のものです。

- アラート（リスト）

![%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0465.jpg](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0465.jpg)

- アラート（バナー）

![](./[iOS%20Swift]%20ローカル通知をやってみる%20a2b8640e310d4b37adebe333b6ccd484/IMG_0531.jpg)

- バッジ

  ![%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0464.jpg](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0464.jpg)

- サウンド

![No Image]()

### アプリケーションのライフサイクル

実は通知を受け取ることはいつでもできても、プログラム上では通知を受け取った際のアプリの状態によって処理が変わってきます。
状態というのは**アプリが今起動しているか**や**アプリが画面上に表示されているか**といったもののことです。

そこで、通知と紐付けて、iOS アプリケーションにおけるライフサイクルを確認しましょう。

**ライフサイクル**とは生まれてから消えるまでの過程のことです。ライフサイクルによってアプリは

- フォアグラウンド（Foreground）

アプリケーションが画面上に表示されている状態のことを指します。

`Active` / `In Active` の 2 種類に細かく分けられます。

- バックグラウンド（Background）

アプリケーションが画面上に表示されていない状態のことを指します。

Backgroundの状態で一定時間起動が続くと、システムが自動的に`Suspended（停止状態）`に切り替えてくれます。
`Suspended`と`Not Running`はどちらもアプリが停止している状態のことです。

|アプリケーションのライフサイクル|
|---|
|![](./[iOS%20Swift]%20ローカル通知をやってみる%20a2b8640e310d4b37adebe333b6ccd484/1x/アートボード%201.png)|

|種類|説明|例|
|---|---|---|
|`Active`|アプリが現在操作中である|使用中|
|`InActive`|アプリの操作から一時的に離れている状態であるが、アプリは表示されている|コントロールセンター・通知センターを表示している状態|
|`Foreground`|`Active`と`InActive`の状態の総称||
|`Background`|別のアプリケーションが表示されている状態。アプリは起動していてバックグランドで特定のタスクが可能||
|`Suspended`|一定時間の`Background`状態が続くと自動的にこの状態になる||
|`Not Running`|アプリが完全に停止している状態||

細かく分けられるものの、アプリケーションには**フォアグラウンド**と**バックグラウンド**の状態があることが重要です。
`Suspended`と`Not Running`に関してはシステムが自動で管理する部分もありあまり開発者でも意識することはありません。

#### AppDelegate について

AppDelegate とは`@UIApplicationMain` の属性をもつクラスで、アプリごとに 1 つのみ存在します。

#### SceneDelegateについて

SceneDelegateとはAppDelegateとは異なり、アプリごとに複数存在することがあります。iOS13から導入された`Multiple Windows`によって一つのアプリを複数のウィンドで操作できることがあるため、アプリケーションのライフサイクルはAppDelegateよりもSceneDelegateの方が優先されるようになりました。(`UIApplicationDelegate#applicationDidBecomeActive`はSceneDelegateが設定されている場合は呼ばれません。)

例えば、アプリがActiveなのかそうでないのかを判断する場合は以下の2つのメソッドを実装する必要があります。

- `func sceneDidBecomeActive(_ scene: UIScene)`
  - シーンのライフサイクルがアクティブになった際に呼ばれます。
- `func sceneWillResignActive(_ scene: UIScene)`
  - シーンのライフサイクルがアクティブでなくなった際に呼ばれます。

### 許可について

通知はアプリをインストールしてくれた全てのユーザーに対して送ることができるわけではありません。

実際に通知を送るには下の画像の様に予めユーザーに許可をとる必要があります。

|通知許可アラート|
|---|
|![Requesting Push Notification Authorization](./[iOS%20Swift]%20ローカル通知をやってみる%20a2b8640e310d4b37adebe333b6ccd484/IMG_8163C4AB0A62-1.jpeg)|

### 通知の許可を送るコード

以下のコードで`アラート` `バッジ` `サウンド`の3つに対して許可のリクエストをすることができます。

```swift
// プッシュ通知の許可を依頼する際のコード
UNUserNotificationCenter.current().requestAuthorization([.alert, .badge, .sound]) { (granted, error) in
    // [.alert, .badge, .sound]と指定されているので、「アラート、バッジ、サウンド」の3つに対しての許可をリクエストした
	if granted {
		// 「許可」が押された場合
	} else {
		// 「許可しない」が押された場合
	}
}
```

## 通知を送信する

### `UNMutableNotificationContent`

通知を送信する際に`UNMutableNotificationContent`というクラスを作成します。

下の例は、その通知によって付与されるバッジの数・通知のタイトル・通知を受信した際のサウンドを決定しています。

```swift
// MARK: 通知の中身を設定
let content: UNMutableNotificationContent = UNMutableNotificationContent()
content.title = notificationTitle
content.sound = UNNotificationSound.default
content.badge = 1
```

### UNNotificationTrigger

次に`UNNotificationTrigger`というクラスを作成します。
`UNNotificationTrigger`はトリガーという言葉が含まれていることから分かる様に、**いつ通知を発行するのか**を設定するためのものです。
実際には以下の4つのクラスを使用してトリガーを作成します。

- `UNCalendarNotificationTrigger`
  - カレンダーを元にするトリガー
    - `DateComponents`を用いて特定の時間帯になると通知が発行される
    - 次の朝9時
    - 毎朝9時
- `UNLocationNotificationTrigger`
  - 位置を元にするトリガー
    - ある特定の地域に位置していると通知が発行される
- `UNTimeIntervalNotificationTrigger`
  - 時間差を元にするトリガー
    - 60秒後
    - 1週間後
- `UNPushNotificationTrigger`
  - リモート通知におけるトリガー

#### 作成例

ある日付データ`notificationDate`に対して年/月/日/時間/分が同じ際に一回のみ通知される際のトリガーは以下のように書けます。

```swift
// MARK: 通知をいつ発動するかを設定
// カレンダークラスを作成
let calendar: Calendar = Calendar.current
let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate), repeats: false)
```

### `UNNotificationRequest`

次に`UNNotificationRequest`というクラスを作成します。

`UNNotificationRequest`は先ほどの`UNNotificationContent`と`UNNotificationTrigger`の二つを用いて作成することができます。

#### 作成例

```swift
// MARK: 通知のリクエストを作成
let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
```

`identifier`には`UUID().uuidString`という一意の(重複して生成されることのない）文字列を使用します。通知ごとにユニークで他と被ることがない必要があります。

### 通知を登録（送信）する

最後に作成した通知リクエストを通知センターに登録して、通知を送信します。
コールバック引数の中で、実際にエラーが返ってきたかどうかを`error: Error?`引数によって判断することができます。

```swift
// MARK: 通知のリクエストを実際に登録する
UNUserNotificationCenter.current().add(request) { (error: Error?) in
    // エラーが存在しているかをif文で確認している
    if error != nil {
        // MARK: エラーが存在しているので、エラー内容をprintする
    } else {
        // MARK: エラーがないので、うまく通知を追加できた        
    }
}
```

### 通知を受け取った際の処理を実装する

設定した時刻になり、ユーザーが通知を受信したときの処理をする必要があります。

`UNUserNotificationCenterDelegate`に準拠した上で、以下の 2 つのメソッドを実装する必要があります。

```swift
class ClassA: UNUserNotificationCenterDelegate {
	// フォアグラウンドの状態でプッシュ通知を受信した際に呼ばれるメソッド
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .list])
	}

	// バックグランドの状態でプッシュ通知を受信した際に呼ばれるメソッド
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		completionHandler()
	}
}
```

通知を受け取った際に、アプリが画面に表示されている（フォアグラウンド）か、そうではない（バックグランド）かで、別のメソッドを実装する必要があることが分かると思います。

頭にある`ClassA` は例で、実際には以下のように`AppDelegate` が`UNUserNotificationCenterDelegate`を準拠して 2 つのメソッドを実装します。

```swift
extension AppDelegate: UNUserNotificationCenterDelegate {
    // フォアグラウンドの状態でプッシュ通知を受信した際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.banner, .list])
	}
	// バックグランドの状態でプッシュ通知を受信した際に呼ばれるメソッド
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		completionHandler()
	}
}
```

---

## 具体的なサンプル

+ボタンから作成したプッシュ通知を一覧画面で確認できるアプリです

- [GitHub](https://github.com/fummicc1-lit/Sample-LocalNotificationApp-iOS)

![demo](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/demo.gif)
