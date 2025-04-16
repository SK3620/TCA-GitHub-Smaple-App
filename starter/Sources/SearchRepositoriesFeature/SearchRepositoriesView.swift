import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

// 検索リポジトリ画面を表示する View
public struct SearchRepositoriesView: View {
    // 検索機能の状態とアクションを管理するStore
    @Perception.Bindable var store: StoreOf<SearchRepositoriesReducer>
    
    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                Toggle(isOn: $store.showFavoritesOnly) {
                    Text("Favorites Only")
                }
            
                
                ForEach(
                    // 親Storeが持っている子要素リストから、それぞれの子要素専用の小さなStoreを作り出す
                    store.scope(state: \.items, action: \.items),
                    id: \.state.id
                ) { itemStore in
                    RepositoryItemView(store: itemStore)
                }
                
                if store.hasMorePage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("GitHubApp")
            .searchable(
                text: $store.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search repositories")
            )
            .onSubmit(of: .search) {
                store.send(.search)
            }
        } destination: { store in
            switch store.case {
            case .repositoryDetail(let store):
                RepositoryDetailFeature.RepositoryDetailView(store: store)
            }
        }
    }
}
