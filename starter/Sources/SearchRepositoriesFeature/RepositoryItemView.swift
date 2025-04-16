import SwiftUI
import ComposableArchitecture
import SharedModel

struct RepositoryItemView: View {
    
    @Perception.Bindable var store: StoreOf<RepositoryItemReducer>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(store.repository.name)
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                
                Label {
                    Text("\(store.repository.stars)")
                        .font(.system(size: 14))
                } icon: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.yellow)
                }
            }
            
            Spacer(minLength: 16)
            
            Button {
                // どちらでも可能 あとで違いを調べる
                // $store.liked.wrappedValue.toggle()
                $store.wrappedValue.liked.toggle()
            } label: {
                Image(systemName: store.liked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.pink)
            }
            .buttonStyle(.plain)
        }
    }
}
