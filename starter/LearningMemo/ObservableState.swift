//
//  ObservableState.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/03.
//

// MARK: - ObservaleState

/*
 状態を持つ構造体（State）に直接バインディングを提供し、ビューがその状態を監視（observe）するために使います。状態が変更されると、ビューが自動的に更新される仕組みです。
 
 4. ObservableStateで簡潔にする
 この @BindingState の複雑さを解消するために @ObservableState という新しい仕組みが導入されました。

 4.1. 変更点
 @BindingState を @ObservableState に置き換える。

 @BindingState を削除してもバインディングが維持される。

 変更前：
 struct State {
   @BindingState var text = ""
   @BindingState var isOn = false
 }
 
 変更後：
 @ObservableState
 struct State {
   var text = ""
   var isOn = false
 }
 
 BindableAction の適用 (enum Action: BindableAction) と BindingReducer は 削除しないこと。これらは引き続き必要。

 5. Viewでのバインディングの書き方
 新しい @ObservableState を適用すると、View 側の WithViewStore も不要になり、よりシンプルな @Bindable を使うことができます。

 変更前（従来の WithViewStore）：
 WithViewStore(store, observe: { $0 }) { viewStore in
   Form {
     TextField("Text", text: viewStore.$text)
     Toggle(isOn: viewStore.$isOn)
   }
 }
 変更後（@Bindable を使う）：

 @Bindable var store: StoreOf<Feature>

 var body: some View {
   Form {
     TextField("Text", text: $store.text)
     Toggle(isOn: $store.isOn)
   }
 }
 この @Bindable によって、ビューが直接 store にアクセスし、バインディングを取得できます。
*/
