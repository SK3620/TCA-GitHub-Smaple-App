import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

// 検索リポジトリ画面を表示する View
public struct SearchRepositoriesView: View {
    // 状態とアクションを管理するStore
    let store: StoreOf<SearchRepositoriesReducer>

    // ViewState は UI に必要なデータをまとめた構造体
    struct ViewState: Equatable {
        var items: [RepositoryItem] = []
        @BindingViewState var query: String // 検索クエリのバインディング
        @BindingViewState var showFavoritesOnly: Bool // お気に入りのみを表示するかのバインディング
        let hasMorePage: Bool // さらにページがあるかどうか
        
        @MainActor
        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self.items = store.filteredItems
            self._query = store.$query
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.hasMorePage = store.hasMorePage
        }
    }
    
    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }
    
    public var body: some View {
        // ViewStore を使用して、状態を監視しながら UI を構築
        WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
            List {
                // お気に入りのリポジトリのみを表示するためのトグルスイッチ
                Toggle(isOn: viewStore.$showFavoritesOnly) {
                    Text("Favorites Only")
                }
                
                // フィルタされたリポジトリをリスト表示
                ForEach(viewStore.items) { item in
                    Text(item.name)
                        .onAppear {
                            viewStore.send(.itemAppeared(id: item.id))
                        }
                }
                // さらにデータがある場合はローディングインジケータを表示
                if viewStore.hasMorePage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            // 検索機能を追加
            .searchable(text: viewStore.$query)
        }
    }
}
