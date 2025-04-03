import SwiftUI
import SearchRepositoriesFeature
import ComposableArchitecture

@main
struct GithubApp: App {
    static let store = Store(initialState: SearchRepositoriesReducer.State()) {
        SearchRepositoriesReducer()
    }
    
    var body: some Scene {
        WindowGroup {
            SearchRepositoriesView(store: Self.store)
        }
    }
}
