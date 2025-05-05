//
//  IdentifiedArrayOf.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/06.
//

/*
 🔍 IdentifiedArrayOfとは？
 IdentifiedArrayOf は TCA（The Composable Architecture）で配列を扱うときによく使う特別な配列 です。

 普通の Array じゃなくて、「各要素に id があって、識別できる配列」を使うことで、TCAが画面の状態管理やリストの操作を効率的にできるようになります。

 🧠 簡単なイメージ
 struct Banana: Identifiable {
     let id: UUID
     var name: String
 }

 let bananas: IdentifiedArrayOf<Banana> = [
     Banana(id: UUID(), name: "バナナ1号"),
     Banana(id: UUID(), name: "バナナ2号")
 ]
 これは「IDつきのバナナの配列」。普通の配列じゃなくて、各バナナがしっかり識別できるから、TCAで使いやすい！

 📦 IdentifiedArrayOf を使ったサンプル
 以下に超簡易な「バナナリスト管理アプリ」のコードを書いてみるよ。

 1. 🍌 Model（状態）
 import Foundation
 import ComposableArchitecture

 struct Banana: Identifiable, Equatable {
     let id: UUID
     var name: String
 }
 
 2. 🔧 State（状態）
 struct BananaListState: Equatable {
     var bananas: IdentifiedArrayOf<Banana> = []
 }
 → bananas は普通の配列じゃなくて IdentifiedArrayOf！

 3. 🛠 Action（ユーザーの操作）
 enum BananaListAction: Equatable {
     case addBanana(name: String)
     case deleteBanana(id: UUID)
 }
 4. ⚙️ Reducer（状態の変更ルール）
 let bananaListReducer = Reducer<BananaListState, BananaListAction, Void> { state, action, _ in
     switch action {
     case let .addBanana(name):
         let newBanana = Banana(id: UUID(), name: name)
         state.bananas.append(newBanana)
         return .none
         
     case let .deleteBanana(id):
         state.bananas.remove(id: id)
         return .none
     }
 }
 → IdentifiedArrayOf だから .remove(id:) が使える！これがめっちゃ便利。

 5. 🖼 View側（表示）
 import SwiftUI

 struct BananaListView: View {
     let store: Store<BananaListState, BananaListAction>
     
     var body: some View {
         WithViewStore(self.store, observe: { $0 }) { viewStore in
             VStack {
                 Button("バナナ追加") {
                     viewStore.send(.addBanana(name: "新バナナ"))
                 }
                 
                 List {
                     ForEach(viewStore.bananas) { banana in
                         Text(banana.name)
                     }
                     .onDelete { indexSet in
                         for index in indexSet {
                             let banana = viewStore.bananas[index]
                             viewStore.send(.deleteBanana(id: banana.id))
                         }
                     }
                 }
             }
         }
     }
 }
 💡 まとめ（超ざっくり）
 用語    意味
 IdentifiedArrayOf<T>    id付きの配列。TCAでリスト管理が便利になる魔法のやつ
 .append()    普通の配列と同じように追加できる
 .remove(id:)    IDでサクッと削除できて超便利
 ForEach(viewStore.bananas)    SwiftUIのリスト表示もラクラク
 ✨ なぜ使うの？
 TCAでは IdentifiedArrayOf を使うと、状態をしっかり個別に管理できるし、Viewとの連携もスムーズになるんだ。普通の [Banana] だと .remove(id:) とかができないから、ゴリゴリ検索して削除する必要が出てくる。

 気になるところがあったらもっと噛み砕いて説明するよ！次は .forEach と組み合わせたサブReducerとかも説明できるよ 🙌




 IdentifiedArrayOf と普通の配列（[T]）の違いを 猿でもわかるレベル で、例とともに解説するね 🐵🍌

 🍎 例で理解しよう！
 ✅ 普通の配列（[Banana]）
 struct Banana: Identifiable {
     let id: UUID
     var name: String
 }

 var bananas: [Banana] = [
     Banana(id: UUID(), name: "バナナ1号"),
     Banana(id: UUID(), name: "バナナ2号")
 ]
 この配列から 特定のIDのバナナを削除 したい場合、こうなる👇

 let targetId = bananas[0].id
 bananas.removeAll { $0.id == targetId }
 📝 自分で .filter や .firstIndex(where:) を書かないと、IDで操作できない。

 🍌 IdentifiedArrayOf を使うと？
 import ComposableArchitecture

 var bananas: IdentifiedArrayOf<Banana> = [
     Banana(id: UUID(), name: "バナナ1号"),
     Banana(id: UUID(), name: "バナナ2号")
 ]

 let targetId = bananas[0].id
 bananas.remove(id: targetId)
 🔧 .remove(id:) のように、IDをキーとして使った便利な操作ができる！

 🔍 違いまとめ
 特徴                  普通の配列 [T]                 IdentifiedArrayOf<T>
 要素に id が必要？      いらない                       必要（Identifiable 準拠）
 要素の取得（id指定）     first(where:) 書く必要あり     array[id] で直接取れる
 削除（id指定）          removeAll(where:) 書く       remove(id:) が使える
 更新（id指定）          firstIndex(where:) 書く      array[id] = newItem で簡単更新
 TCAとの相性            あまり良くない    超バッチリ◎

*/
