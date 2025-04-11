//
//  Dependency.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/11.
//

import Foundation
import Dependencies

// 依存関係のキーを定義
// 例えば、MyValueKeyという名前のキーを作成し、そこに依存関係の値を設定します。
private enum MyValueKey: DependencyKey {
  static let liveValue = 42  // 依存関係の値
}

// DependencyValuesに依存関係を追加
// myValueという依存関係を使えるようにする
extension DependencyValues {
  var myValue: Int {
    get { self[MyValueKey.self] }   // 値を取得
    set { self[MyValueKey.self] = newValue }  // 値を設定
  }
}

// 依存関係を使う例
struct Example {
    @Dependency(\.myValue) var myValue  // 依存関係を取得

  func printValue() {
    print("依存関係の値: \(myValue)")  // 依存関係の値を出力
  }

  func updateValue() {
    myValue = 100  // setterによって依存関係の値を変更
  }
}

// 使用例
var example = Example()
example.printValue()  // "依存関係の値: 42"が出力される
example.updateValue()  // 依存関係の値を100に変更
example.printValue()  // "依存関係の値: 100"が出力される
