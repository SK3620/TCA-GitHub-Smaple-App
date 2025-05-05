//
//  Equatable.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/03/30.
//

// MARK: - Equatable
/*
 Equatable なしの場合（比較できない 😢）
 struct Banana {
     let size: Int
 }

 let banana1 = Banana(size: 10)
 let banana2 = Banana(size: 10)

 // これはエラーになる！
 print(banana1 == banana2) // ❌ コンパイルエラー！「比較の仕方がわからない！」
 👉 エラーの理由
 Swift は banana1 と banana2 が同じかどうかを どうやって比べるのかわからない ので、エラーになります。

 Equatable をつけた場合（比較できる 🎉）
 struct Banana: Equatable {
     let size: Int
 }

 let banana1 = Banana(size: 10)
 let banana2 = Banana(size: 10)

 print(banana1 == banana2) // ✅ true（サイズが同じだから）
 👉 Equatable をつけると？
 Swift が 「size が同じなら同じバナナ」 って自動的に判断してくれる！


 */
