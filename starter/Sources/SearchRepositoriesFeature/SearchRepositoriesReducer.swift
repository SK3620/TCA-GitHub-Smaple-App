import ComposableArchitecture
import SwiftUI
import Foundation
import RepositoryDetailFeature

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
        
        var path = StackState<RepositoryDetailReducer.State>()
        
        public init() {}
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>) // バインディング変更時のアクション
        case itemAppeared(id: Int) // リストのアイテムが表示されたときのアクション
        case path(StackActionOf<RepositoryDetailReducer>)
    }
        
    public var body: some ReducerOf<Self> {
        BindingReducer() // BindingActionを受け取った時の、"@BindingState"を更新するためのReducer
        Reduce { state, action in
            switch action {
            case .binding:
                return .none // BindingReducer()で自動で処理されるので特に何もしなくてOK
            case .itemAppeared:
                return .none // アイテムが表示されたときの処理（現在は未実装）
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            RepositoryDetailReducer()
        }
    }
}

public struct RepositoryItem: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let liked: Bool
}
