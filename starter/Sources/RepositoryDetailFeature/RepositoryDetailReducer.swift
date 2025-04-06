import ComposableArchitecture
import Dependencies
import Foundation
import SharedModel

@Reducer
public struct RepositoryDetailReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
//        public var id: Int { repository.id }
//        public let repository: Repository
//        public var liked = false
//
//        public init(
//            repository: Repository,
//            liked: Bool
//        ) {
//            self.repository = repository
//            self.liked = liked
//        }
        
        public init() {}
    }

    public init() {}

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

