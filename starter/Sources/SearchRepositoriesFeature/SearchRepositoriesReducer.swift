import ComposableArchitecture
import SwiftUI
import Foundation
import RepositoryDetailFeature
import SharedModel
import GithubClient

@Reducer
public struct SearchRepositoriesReducer: Reducer, Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable { // ※Sendableに準拠するとエラー
        var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
        var query: String = ""
        var showFavoritesOnly = false
        var hasMorePage = false
                
        var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
            items.filter {
                !showFavoritesOnly || $0.liked
            }
        }
        
        var loadingState: LoadingState = .refreshing
        
        // 画面の状態を積み上げる
         var path = StackState<Path.State>()
        
        public init() {}
    }
    
    // どんな画面を積み上げるかを定義
    @Reducer(state: .equatable)
    public enum Path {
        case repositoryDetail(RepositoryDetailReducer)
    }
    
    enum LoadingState: Equatable {
        case refreshing
        case loadingNext
        case none
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>) // バインディング変更時のアクション
        case items(IdentifiedActionOf<RepositoryItemReducer>)
        case itemAppeared(id: Int) // リストのアイテムが表示されたときのアクション
        case itemTapped(item: Repository, liked: Bool) // リストのアイテムの押下時のアクション
        case search // 検索押下時
        case searchReposResponse(Result<SearchReposResponse, Error>) // 受け取った検索結果を流す
        case path(StackActionOf<Path>) // 子画面からのイベントを受け取る窓口
    }
    
    // MARK: - Dependencies
    @Dependency(\.githubClient) var githubClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none // BindingReducer()で自動で処理されるので特に何もしなくてOK
            case .items:
                return .none
            case .itemAppeared:
                return .none
            case let .itemTapped(item, liked):
                let repositoryDetailReducerState = RepositoryDetailReducer.State(item: item, liked: liked)
                state.path.append(.repositoryDetail(repositoryDetailReducerState))
                return .none
            case .search:
                state.loadingState = .refreshing
                return .run { [query = state.query] send in
                    // init(catching body: () async throws(Failure) -> Success) async 「async」なのでawaitつける
                    let result = await Result(catching: { () async throws -> SearchReposResponse in
                        try await githubClient.searchRepos(query, 0)
                    })
                    // let result: Result<SearchReposResponse, any Error>
                    await send(.searchReposResponse(result))
                }
            case let .path(.element(id: id, action: .repositoryDetail(.binding(_)))):
                // case let .path(.element(id: id, action: .binding(\.$liked))): コンパイルエラー
                /*
                public enum StackAction<State, Action>: CasePathable {
                    indirect case element(id: StackElementID, action: Action)
                }
                 */
                guard let repositoryDetail = state.path[id: id]?.repositoryDetail else { return .none }
                state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
                return .none
            case .path:
                return .none
            case .searchReposResponse(.success(let response)):
                switch state.loadingState {
                case .loadingNext:
                    print("loadingNext")
                case .refreshing:
                    let newItems = IdentifiedArray(uniqueElements: response.items.map { RepositoryItemReducer.State(repository: Repository(from: $0)) })
                    state.items = newItems
                case .none:
                    break
                }
                
                state.loadingState = .none
                return .none
            case .searchReposResponse(.failure):
                return .none
            }
        }
        // それぞれの子に対応するロジック（Reducer）を割り当てる
        .forEach(\.items, action: \.items) {
            RepositoryItemReducer()
        }
        // 各子画面の処理を親とつなげる
        .forEach(\.path, action: \.path)
    }
}
