import SwiftUI
import SearchRepositoriesFeature
import ComposableArchitecture

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
//            SearchRepositoriesView(store: .init(initialState: .init()) {
//                SearchRepositoriesReducer()
//            })
            
            RootView(store: .init(initialState: .init(), reducer: {
                RootReducer()
            }))
        }
    }
}
