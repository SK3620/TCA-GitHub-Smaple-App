import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

// 検索リポジトリ画面を表示する View
public struct SearchRepositoriesView: View {
    // 検索機能の状態とアクションを管理するStore
    @Perception.Bindable var store: StoreOf<SearchRepositoriesReducer>
    
    public var body: some View {
        List {
            Toggle(isOn: $store.showFavoritesOnly) {
                Text("Favorites Only")
            }
            // リポジトリのリストを表示
            ForEach(store.items) { item in
                Text(item.name) // リポジトリの名前を表示
                    .onAppear {
                        // ユーザーがこのアイテムをスクロールして表示したときに通知を送る
                        store.send(.itemAppeared(id: item.id))
                    }
            }
            // さらにデータがある場合はローディングインジケータを表示
            if store.hasMorePage {
                ProgressView() // ローディング中のインジケータ
                    .frame(maxWidth: .infinity) // 幅いっぱいに広げる
            }
        }
        // 検索バーを追加し、検索クエリをバインディングする
        .searchable(text: $store.query)
    }
}
