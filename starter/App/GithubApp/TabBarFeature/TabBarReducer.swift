//
//  TabBarReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture

public enum Tab: Equatable {
    case home
    case search
    case profile
}

@Reducer
public struct TabBarReducer {
    
    @ObservableState
    public struct State: Equatable, Hashable {
        var selectedTab: Tab = .home
    }
    
    public enum Action: Equatable {
        case didSelectTab(Tab)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case didSelectTab(Tab)
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .didSelectTab(tab):
                return .send(.delegate(.didSelectTab(tab)))
            case .delegate:
                return .none
            }
        }
    }
}
