import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
public struct SearchRepositoriesReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var items: [RepositoryItem] = []
        var query: String = ""
        var showFavoritesOnly = false
        var hasMorePage = false
        
        var filteredItems: [RepositoryItem] {
            return self.items.filter { !showFavoritesOnly || $0.liked }
        }
        
        public init() {}
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>) // バインディング変更時のアクション
        case itemAppeared(id: Int) // リストのアイテムが表示されたときのアクション
    }
        
    public var body: some ReducerOf<Self> {
        BindingReducer() // BindingActionを受け取った時の、"@BindingState"を更新するためのReducer
        Reduce { _, action in
            switch action {
            case .binding:
                return .none // BindingReducer()で自動で処理されるので特に何もしなくてOK
            case .itemAppeared:
                return .none // アイテムが表示されたときの処理（現在は未実装）
            }
        }
    }
}

public struct RepositoryItem: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let liked: Bool
}
