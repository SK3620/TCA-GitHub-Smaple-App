//
//  ForEach.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/16.
//


import ComposableArchitecture
import SwiftUI // UUID を使うためにインポート

// ① 子要素一人の状態（データ）
@ObservableState // これが新しい書き方の目印！
struct ChildState: Equatable, Identifiable { // Identifiable でないと ForEach で使いにくい
  let id: UUID // 一人一人を見分けるための番号（ID）
  var name: String
  var count: Int = 0
}

// ② 子要素ができる操作（アクション）
enum ChildAction: Equatable {
  case incrementButtonTapped
  case decrementButtonTapped
}

// ③ 子要素の指示役（Reducer）
@Reducer
struct Child {
  // 状態とアクションを紐付け
  typealias State = ChildState
  typealias Action = ChildAction

  // アクションが来た時にどう状態を変えるか
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .incrementButtonTapped:
        state.count += 1
        return .none // 何か特別な副作用（通信とか）は起こさない
      case .decrementButtonTapped:
        state.count -= 1
        return .none
      }
    }
  }
}

import ComposableArchitecture
import Foundation

// ④ 親要素の状態（データ）
@ObservableState // これも新しい書き方
struct FeatureState: Equatable {
  // IdentifiedArrayOf は、ID付きの要素をたくさん持つための特別な配列
  var children: IdentifiedArrayOf<Child.State> = [
    // 最初からいくつか子要素を入れておく例
    ChildState(id: UUID(), name: "タロウ"),
    ChildState(id: UUID(), name: "ハナコ"),
    ChildState(id: UUID(), name: "ジロウ")
  ]
}

// ⑤ 親要素ができる操作（アクション）
enum FeatureAction: Equatable {
  // 子要素たちの誰かのアクションをまとめて受け取る
  // IdentifiedActionOf は、どの子のどのアクションかを特定するためのもの
  case children(IdentifiedActionOf<Child>)
  case addButtonTapped
  case removeLastButtonTapped
}

// ⑥ 親要素の指示役（Reducer）
@Reducer
struct Feature {
  // 状態とアクションを紐付け
  typealias State = FeatureState
  typealias Action = FeatureAction

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .children:
        // 子要素のアクションはここでは何もしない（子Reducerに任せる）
        return .none

      case .addButtonTapped:
        // 新しい子要素を追加
        let newChild = ChildState(id: UUID(), name: "新しい子 \(state.children.count + 1)")
        state.children.append(newChild)
        return .none

      case .removeLastButtonTapped:
        // 最後の子要素を削除 (もしいたら)
        if !state.children.isEmpty {
          state.children.removeLast()
        }
        return .none
      }
    }
    // 子要素たちの Reducer をここに組み込む
    // children の中のどの子のアクションかを見て、対応する Child Reducer に処理を渡す
    .forEach(\.children, action: \.children) {
      Child() // Child Reducer を使うよ、と指定
    }
  }
}

//FeatureState: 親が持つデータです。ここでは children という名前で、たくさんの ChildState を IdentifiedArrayOf という特殊な配列で持っています。これは ID で要素を管理するのに便利な配列です。
//FeatureAction: 親ができる操作です。case children(IdentifiedActionOf<Child>) は、「たくさんの子要素の誰かから、何かアクションが来たよ」というのをまとめて受け取るための書き方です。どの子 (Identified) のどのアクション (ActionOf<Child>) かを区別できます。addButtonTapped や removeLastButtonTapped は親自身の操作です。
//Feature Reducer: 親のアクションが来た時に FeatureState をどう変えるかを決めます。
//.children ケース: 子から来たアクションは、ここでは何もしません。下の .forEach が担当します。
//.addButtonTapped: 新しい ChildState を作って children 配列に追加します。
//.removeLastButtonTapped: 配列から最後の要素を削除します。
//.forEach(\.children, action: \.children): これが重要！ FeatureState の中の children 配列と、FeatureAction の中の .children ケースを結びつけます。そして、各子要素に対して Child Reducer を適用するように指示しています。これにより、特定の子要素のアクションは、その子要素を担当する Child Reducer に自動的に送られます。

import SwiftUI
import ComposableArchitecture

struct ChildView: View {
  // この View 専用の指示役（Store）を受け取る
  let store: StoreOf<Child>

  var body: some View {
    HStack {
      Text("\(store.name): \(store.count)") // 子の名前とカウントを表示
      Spacer()
      Button("+") {
        // "+" ボタンが押されたら、incrementButtonTapped アクションを送る
          store.send(.incrementButtonTapped)
      }
      Button("-") {
        // "-" ボタンが押されたら、decrementButtonTapped アクションを送る
        store.send(.decrementButtonTapped)
      }
    }
  }
}
//store: StoreOf<Child>: この View が担当する子要素一人のための指示役（Store）を受け取ります。
//Text("\(store.name): \(store.count)"): store を通して、子要素の状態（名前とカウント）を表示します。@ObservableState のおかげで、カウントが変わると自動で表示が更新されます。
//Button("+") { store.send(...) }: ボタンが押されたら、store を通して ChildAction を Reducer に送ります。
//親要素の見た目 (FeatureView)

import SwiftUI
import ComposableArchitecture

struct FeatureView: View {
  // この View の指示役（Store）を受け取る
  let store: StoreOf<Feature>

  var body: some View {
    NavigationView { // ナビゲーションバーなどを表示するため
      List { // リスト形式で表示
        // ここが今回のポイント！ SwiftUI の ForEach を使う
        ForEach(
          // ① 親 Store から、子要素たち (children) のための Store の集まりを作る
          store.scope(state: \.children, action: \.children),
          // ② 各要素を、その状態の id プロパティで区別する
          id: \.state.id
        ) { childStore in
          // ③ それぞれの子要素に ChildView を表示し、その子専用の Store (childStore) を渡す
          ChildView(store: childStore)
        }
      }
      .navigationTitle("親子リスト")
      .toolbar { // ナビゲーションバーにボタンを追加
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("追加") {
            store.send(.addButtonTapped) // 追加ボタンのアクションを送る
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Button("削除") {
            store.send(.removeLastButtonTapped) // 削除ボタンのアクションを送る
          }
        }
      }
    }
  }
}

//store: StoreOf<Feature>: 親 View のための指示役を受け取ります。
//List { ... }: 子要素をリストで表示します。
//ForEach(...): ここが ForEachStore からの変更点です！
//store.scope(state: \.children, action: \.children):
//これは親の store に対して、「あなたの持っている children という状態（State）と、それに対応する children というアクション（Action）に注目してね」と伝えています。
//具体的には、FeatureState の中の children 配列（IdentifiedArrayOf<Child.State>）と、FeatureAction の .children ケース (IdentifiedActionOf<Child>) を使って、子要素一人一人に対応する Store<Child.State, Child.Action> (つまり StoreOf<Child>) の集まり を作り出します。イメージとしては、親 Store が持っている子要素リストから、それぞれの子要素専用の小さな Store を一時的に作り出す感じです。
//id: \.state.id:
//ForEach は、リストの各行を区別するために、それぞれの要素が持つユニークな「名札」（ID）を必要とします。
//store.scope(...) が作り出すのは StoreOf<Child> の集まりです。この StoreOf<Child> は、それぞれが対応する Child.State を内部に持っています。
//\.state.id と書くことで、「それぞれの Store が持っている state プロパティの中の id プロパティを名札として使ってね」と指示しています。ChildState が Identifiable で id を持っているので、これが可能です。 SwiftUI はこの id を見て、どの行がどのデータに対応するのか、行が追加/削除/移動されたときに効率的に画面を更新します。
//{ childStore in ChildView(store: childStore) }:
//ForEach は、store.scope(...) が作った子要素用 Store の集まりを一つずつ取り出して、childStore という名前でクロージャ（{...} の部分）に渡します。
//クロージャの中では、受け取った childStore を使って ChildView を作り、表示します。これにより、リストの各行に、対応する子要素の情報と操作ボタンが表示されるわけです。
