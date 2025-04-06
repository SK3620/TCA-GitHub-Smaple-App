import SwiftUI
import ComposableArchitecture
import SharedModel

public struct RepositoryDetailView: View {
    @Perception.Bindable var store: StoreOf<RepositoryDetailReducer>
    
    public init(store: StoreOf<RepositoryDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Hello World")
    }
}
