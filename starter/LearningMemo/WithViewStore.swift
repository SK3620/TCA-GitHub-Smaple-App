//
//  WithViewStore.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/03/28.
//

// MARK: - WithViewStore
/*
 Deprecated

 Use '@ObservableState', instead. See the following migration guide for more information: https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.7#Using-ObservableState
 
 Store のデータ (State) を SwiftUI で簡単に扱えるようにするラッパー
 Viewによってstoreが持つReducerで管理しているState（状態）の変化を監視できるようにする
 A view helper that transforms a Store into a ViewStore so that its state can be observed by a view builder.

 
 let store = 〜〜〜
 WithViewStore(store) { viewStore in
     TextField("検索", text: viewStore.$query)
 }
 ・store は そのReducer で管理している状態 (State) を持ってる
 ・WithViewStore を使うと、その store から State を リアクティブに 取り出せる
 ・さらに、viewStore.$query のように $ をつけると 双方向バインディング（Binding） できる！
*/
