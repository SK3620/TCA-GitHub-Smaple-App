// MARK: - BindingState
/*
 ビューでユーザーが操作した値を、Reducer に自動で伝えるためのもの
 たとえば、TextField の入力内容を Reducer の状態に反映させたいときに使う。
 （TCA (Composable Architecture) における @Binding みたいなもの）
 
 // 注意 BindingStateだけでは、"@BindingState var query: String"のqueryの値がbindingで更新されない。そのため、Bindable<Action>などの記述が必要

 
 🍌 例1: @BindingState を使わない場合（手動で変更を伝える）
 struct State: Equatable {
     var query: String = ""
 }

 // View側でstore.send(.queryChanged("こんにちは"))でアクションを発行
 enum Action {
     case queryChanged(String)
 }

 let reducer = Reduce<State, Action> { state, action in
     switch action {
     case let .queryChanged(newQuery):
         state.query = newQuery
         return .none
     }
 }
 
 🍌 例2: @BindingState を使う（自動でバインド）
 struct State: Equatable {
     @BindingState var query: String = ""
 }

 enum Action: BindableAction {
     case binding(BindingAction<State>)
 }

 let reducer = Reduce<State, Action> { state, action in
     return .none
 }
 .binding()
 
 // View側
 WithViewStore(store) { viewStore in
     TextField("検索", text: viewStore.$query) // これだけでOK！
 }
 これで、ユーザーが TextField に入力すると、TCA の状態 (query) も自動で更新される！
*/
