import ComposableArchitecture
import Dependencies
import Foundation
import SharedModel

@Reducer
public struct RepositoryDetailReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public let repository: RepositoryItem

        public init(
            item: RepositoryItem
        ) {
            self.repository = item
        }
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

