//
//  WithViewStore.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/03/28.
//

// MARK: - WithViewStore
/*
 Store のデータ (State) を SwiftUI で簡単に扱えるようにするラッパー
 
 let store = 〜〜〜
 WithViewStore(store) { viewStore in
     TextField("検索", text: viewStore.$query)
 }
 ・store は そのReducer で管理している状態 (State) を持ってる
 ・WithViewStore を使うと、その store から State を リアクティブに 取り出せる
 ・さらに、viewStore.$query のように $ をつけると 双方向バインディング（Binding） できる！
*/

