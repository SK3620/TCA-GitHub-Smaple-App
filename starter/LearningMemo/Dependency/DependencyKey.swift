//
//  DependencyKey.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/12.
//

// MARK: - liveValue, testValue

/*
 🐵 まずは例：バナナを配るクライアントを作ろう！
 // バナナを配るためのクライアント
 struct BananaClient {
     var giveBanana: () -> String
 }
 この BananaClient は、「バナナをあげる」機能を持ってるだけのクライアント。

 🍌 本番用の liveValue
 import Dependencies

 extension BananaClient: DependencyKey {
     static let liveValue: BananaClient = .init(
         giveBanana: {
             return "🍌 本物のバナナをどうぞ"
         }
     )
 }
 ここで liveValue を定義してる。

 🧠 意味はこう：
 「アプリが実際に動くとき（本番のとき）はこのバナナを配る処理を使ってね」

 ✅ 実際に使う
 @Dependency(\.bananaClient) var bananaClient

 func feedMonkey() {
     print(bananaClient.giveBanana())  // → 🍌 本物のバナナをどうぞ
 }
 このとき、bananaClient は自動的に liveValue が使われる！
 Dependencies が自動で liveValue を使う！
 Dependenciesフレームワークが「今は本番中だな」と判断して、liveValue を使ってくれる。

 🧪 テストでは testValue にすり替えられる！
 extension BananaClient: TestDependencyKey {
     static let testValue: BananaClient = .init(
         giveBanana: {
             return "🧪 テスト用バナナ"
         }
     )
 }
 テスト中はこっちが使われるので、本物の処理を呼ばなくてすむ！

 🐵🐵🐵 つまり、まとめると：
 名前    使われるとき    内容
 liveValue    アプリが実際に動くとき    本物の処理（API、バナナなど）
 testValue    テストやプレビューのとき    ダミーの処理
 
 🗣️ 猿のセリフで例えるなら：
 本番猿：「うほっ！これが本物の🍌か！ありがとう liveValue！」
 テスト猿：「おや？これはテスト用の🍌だな。まあいいや、testValue ありがとう！」


 */
