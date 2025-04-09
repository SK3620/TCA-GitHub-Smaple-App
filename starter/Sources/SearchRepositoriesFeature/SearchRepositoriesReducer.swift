import ComposableArchitecture
import SwiftUI
import Foundation
import RepositoryDetailFeature
import SharedModel

@Reducer
public struct SearchRepositoriesReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var items: IdentifiedArrayOf<RepositoryItem> = [
            RepositoryItem(id: 1, name: "Repo1", liked: true),
            RepositoryItem(id: 2, name: "Repo2", liked: false),
            RepositoryItem(id: 3, name: "Repo3", liked: true)
        ]
        var query: String = ""
        var showFavoritesOnly = false
        var hasMorePage = false
        
        var filteredItems: [RepositoryItem] {
            return self.items.filter { !showFavoritesOnly || $0.liked }
        }
        
        // 画面の状態を積み上げる
        var path = StackState<Path.State>()
        
        public init() {}
    }
    
    // どんな画面を積み上げるかを定義
    @Reducer(state: .equatable)
    public enum Path {
        case repositoryDetail(RepositoryDetailReducer)
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>) // バインディング変更時のアクション
        case itemAppeared(id: Int) // リストのアイテムが表示されたときのアクション
        case itemTapped(item: RepositoryItem) // リストのアイテムの押下時のアクション
        case search // 検索押下時
        case path(StackActionOf<Path>) // 子画面からのイベントを受け取る窓口
    }
        
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none // BindingReducer()で自動で処理されるので特に何もしなくてOK
            case .itemAppeared:
                return .none
            case .itemTapped(let item):
                let repositoryDetailReducerState = RepositoryDetailReducer.State(item: item)
                state.path.append(.repositoryDetail(repositoryDetailReducerState))
                return .none
            case .search:
                print(state.query)
                return .none
            case .path:
                return .none
            }
        }
        // 各子画面の処理を親とつなげる
        .forEach(\.path, action: \.path)
    }
}
