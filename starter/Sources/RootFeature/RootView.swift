//
//  RootFeature.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture
import TabBarFeature

public struct RootView: View {
    @Perception.Bindable var store: StoreOf<RootReducer>
    
    public init(store: StoreOf<RootReducer>) {
        UITabBar.appearance().isHidden = true
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                TabView(selection: $store.tabBar.selectedTab.sending(\.tabBar.didSelectTab)) {
                    Text("Home")
                        .tag(Tab.home)
                        .toolbar(.hidden, for: .tabBar)
                    
                    Text("Search")
                        .tag(Tab.search)
                        .toolbar(.hidden, for: .tabBar)
                    
                    Text("Profile")
                        .tag(Tab.profile)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                CustomTabBar(store: store.scope(state: \.tabBar, action: \.tabBar))
            }
            .ignoresSafeArea()
        }
    }
}
