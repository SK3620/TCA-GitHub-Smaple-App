//
//  RootFeature.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture
import Foundation
import HomeFeature
import SearchFeature
import ProfileFeature
import TabBarFeature

@Reducer
public struct RootReducer: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var homeReducer: HomeReducer.State = .init()
        var searchReducer: SearchRepositoriesReducer.State = .init()
        var profileReducer: ProfileReducer.State = .init()
        var tabBarReducer: TabBarFeature.State
        
        public init() {}
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case homeTab(HomeFeature.Action)
        case searchTab(SearchFeature.Action)
        case profileTab(ProfileFeature.Action)
        case tabBar(TabBarFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}
