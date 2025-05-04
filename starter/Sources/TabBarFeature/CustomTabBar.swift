//
//  TabBarReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture

public struct CustomTabBar: View {
    let store: StoreOf<TabBarFeature>
    
    public init(store: StoreOf<TabBarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        HStack {
            Button {
                store.send(.didSelectTab(.home))
            } label: {
                Image(systemName: store.selectedTab == .home ? "house.fill" : "house")
            }
            
            Spacer()
            
            Button {
                store.send(.didSelectTab(.search))
            } label: {
                Image(systemName: store.selectedTab == .search ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
            }
            
            Spacer()
            
            Button {
                store.send(.didSelectTab(.profile))
            } label: {
                Image(systemName: store.selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle")
            }
        }
        .padding()
    }
}
