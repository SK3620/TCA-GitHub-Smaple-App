//
//  Deprecated-BindingState.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/03.
//

// MARK: - ああ

/*
 1. @BindingStateの問題点と歴史
 これまで、Composable Architecture（TCA）では、バインディング（データの双方向のやり取り）を行うために、以下のような多くの異なる型が使われていました。

 @BindingState

 BindableAction

 BindingAction

 BindingViewState

 BindingViewStore

 これは、状態 (State) に対してビュー (View) で双方向バインディングを持たせるための仕組みでした。しかし、これらの多くの型を組み合わせる必要があり、コードが複雑になってしまっていました。

 2. 旧来の@BindingStateの使い方
 例えば、以下のような状態 (State) を持つ Feature というリデューサー（状態管理の仕組み）を考えます。

 @Reducer
 struct Feature {
   struct State {
     @BindingState var text = ""
     @BindingState var isOn = false
   }
   enum Action: BindableAction {
     case binding(BindingAction<State>)
   }
   var body: some ReducerOf<Self> { /* ... */ }
 }
ここで、@BindingState は text と isOn をバインディング可能な状態にするためのプロパティラッパー。
Action で BindableAction を適用し、binding(BindingAction<State>) というアクションを定義。
この State を View で使うには ViewStore を介してバインディングを取得します。

WithViewStore(store, observe: { $0 }) { viewStore in
   Form {
     TextField("Text", text: viewStore.$text)
     Toggle(isOn: viewStore.$isOn)
   }
 }
 3. ViewStateを使う場合
 もし View の中で State のデータを整理する ViewState を作ると、さらにコードが増えます。

 struct ViewState: Equatable {
   @BindingViewState var text: String
   @BindingViewState var isOn: Bool
   init(store: BindingViewStore<Feature.State>) {
     self._text = store.$text
     self._isOn = store.$isOn
   }
 }

 var body: some View {
   WithViewStore(store, observe: ViewState.init) { viewStore in
     Form {
       TextField("Text", text: viewStore.$text)
       Toggle(isOn: viewStore.$isOn)
     }
   }
 }
 @BindingViewState を使い、ViewState を通じて View にバインディングを渡していますが、コードがかなり冗長になっています。
 
 → 要するに、複雑！とにかくコード量が多い！
 → ObservableStateと@Bindableを使おう！
 */
