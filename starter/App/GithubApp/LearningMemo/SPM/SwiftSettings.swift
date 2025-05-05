//
//  SwiftSettings.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

/*
 🧠 swiftSettingsって何？
 Swiftコンパイラに「こうやってビルドしてね！」って細かい指示を出す場所です。

 swiftSettings: [
     .unsafeFlags([
         "-strict-concurrency=complete"
     ])
 ]
 上記は、 「Swiftよ、すべての並行処理コード（asyncとか）を超厳しくチェックしてね！」
 → バグが入りにくくなる！
 
 
 // 他にはこんなものがある
 3. -warnings-as-errors
 目的：警告もビルドエラー扱いにする

 使いどき：コード品質を厳しく管理したいとき

 🗣️「警告すら許さねぇ！」
 */
