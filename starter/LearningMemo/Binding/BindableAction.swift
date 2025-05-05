//
//  BindableAction.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/03/28.
//

// MARK: - BindableAction BindingReducer()
/*
import SwiftUI
import ComposableArchitecture

// 🌟 1. State（アプリの状態を定義）
struct SearchState: Equatable {
    @BindingState var query: String = "" // 検索ワード
    @BindingState var showFavoritesOnly: Bool = false // お気に入りのみ表示するか
}

// 🌟 2. Action（ユーザーの操作を定義）
enum SearchAction: BindableAction {
    case binding(BindingAction<SearchState>) // @BindingState の変更を処理
    case search // 検索ボタンが押されたときのアクション
}

// 🌟 3. Reducer（状態を変更するロジック）
struct SearchReducer: Reducer {
    var body: some ReducerOf<Self> {
        BindingReducer() // これを入れるだけでOK @BindingState の変更を自動でTCAが処理してくれる！
        Reduce { state, action in
            switch action {
            case .binding:
                return .none // バインディングの変更は自動で処理されるので特に何もしなくてOK
            case .search:
                print("検索実行！ワード: \(state.query) お気に入りのみ: \(state.showFavoritesOnly)")
                return .none
            }
        }
    }
}

// 🌟 4. View（UI を作成）
struct SearchView: View {
    let store: StoreOf<SearchReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                // 🔍 検索バー
                TextField("検索ワードを入力", text: viewStore.$query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // ⭐ お気に入りフィルター
                Toggle("お気に入りのみ表示", isOn: viewStore.$showFavoritesOnly)
                    .padding()

                // 🔍 検索ボタン
                Button("検索") {
                    viewStore.send(.search) // 検索ボタンが押されたことを通知
                }
                .padding()
            }
            .padding()
        }
    }
}
 
 ❌ BindingReducer() がない場合
 もし BindingReducer() を使わなかったら、バインディングの変更を手動で処理する必要 がある。
 例えば、query や showFavoritesOnly の変更を反映するには、こんなコードを書く必要があるんだ。
 
BindingReducer() なしの例
 Reduce { state, action in
     switch action {
     case .binding(let bindingAction):
         // @BindingState の値が変わるたびに、手動で state に適用する
         state = bindingAction.apply(to: state)
         return .none
     default:
         return .none
     }
 }
 これだと、バインディングのたびに手動で state を更新する処理 を書かないといけない。
 めんどくさいよね？ 🥲
 */

