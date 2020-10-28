# [iOS Swift] ローカル通知をやってみる

## はじめに

この記事では iOS アプリでプッシュ通知について説明します。

## これから学ぶ知識

- 通知とは
- AppDelegate について
- UNUserNotificationCenter について
- 具体的な実装方法

## 通知とは

### 概要

スマートフォンを使っていると 1 日に 1 度はみることのある**通知**は、**ユーザーがアプリを開いていなくてもアプリに関する情報を伝えられる**というメリットが強力です。

例えば、アラームアプリはユーザーがアプリを開いていなくてもその時刻が来たことを適切に伝えてくれます。

また、通知にはいくつかの種類がありますが、よく使われるのは以下の 3 つです。

- アラート（バナーとリストの 2 種類がある）

![%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0465.jpg](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0465.jpg)

- バッジ

  ![%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0464.jpg](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0464.jpg)

- サウンド

（画像なし）

### アプリケーションのライフサイクル

実は通知を受け取ることはいつでもできても、プログラム上では通知を受け取った際のアプリの状態によって処理が変わってきます。

そこで、通知と紐付けて、iOS アプリケーションにおけるライフサイクルを確認しましょう。

ライフサイクル ... 生まれてから消えるまでの過程のこと

- フォアグラウンド（Foreground）

アプリケーションが画面上に表示されている状態のことを指します。

`Active` / `In Active` の 2 種類に細かく分けられます。

- バックグラウンド（Background）

アプリケーションが画面上に表示されていない状態のことを指します。

一定時間のバックグランド状態の持続によって自動的に停止状態に移ります。

細かく分けられるものの、アプリケーションには**フォアグラウンド**と**バックグラウンド**の状態があることを抑えましょう。

### 許可について

通知はアプリをインストールしてくれた全てのユーザーに対して送ることができるわけではありません。

実際に通知を送るには予めユーザーに許可をとる必要があります。

![%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0466.jpg](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/IMG_0466.jpg)

許可を取る際には、上で説明した通知の種類（アラート・サウンド・バッジ など）を指定します。

```swift
// プッシュ通知の許可を依頼する際のコード
UNUserNotificationCenter.current().requestAuthorization([.alert, .badge, .sound]) { (granted, error) in
    // [.alert, .badge, .sound]と指定されているので、「アラート、バッジ、サウンド」の3つに対しての許可をリクエストした
}
```

### 通知が来た際の処理を実装する

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

もう一つ、AppDelegate についての理解も必要なので確認しましょう。

---

## AppDelegate について

AppDelegate とは`@UIApplicationMain` の属性をもつクラスで、アプリごとに 1 つのみ存在します。

---

## UNUserNotificationCenter について

通知の追加や削除などの処理や通知の許可などが実装されたクラスです。

細かいことは使っていく上で理解していきましょう。

---

## 具体的なサンプル

+ボタンから作成したプッシュ通知を一覧画面で確認できるアプリです

- [GitHub](https://github.com/fummicc1-lit/Sample-LocalNotificationApp-iOS)

![demo](%5BiOS%20Swift%5D%20%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E9%80%9A%E7%9F%A5%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%20a2b8640e310d4b37adebe333b6ccd484/demo.gif)
