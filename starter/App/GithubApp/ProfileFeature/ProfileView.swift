//
//  ProfileReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @Perception.Bindable var store: StoreOf<ProfileReducer>
    
    public init(store: StoreOf<ProfileReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Profile")
    }
}
