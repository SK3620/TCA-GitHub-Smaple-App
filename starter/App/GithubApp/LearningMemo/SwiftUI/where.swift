//
//  where.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/12.
//

/*
 where は、Swiftの**「制約をつけるキーワード」**なんだよ。
 超ざっくり言うと、

 「○○なときだけこのコードOK！」って条件をつけるためのやつ。

 🧠 どこで使うの？
 プロトコル継承時

 ジェネリクス（型パラメータ）使ってる関数・型

 extension や func の中 など

 🐵 猿でもわかるレベルの例
 🐒 バナナだけ受け取れる関数を作るとき：
 func feed<T>(item: T) where T == Banana {
     print("バナナを食べました！🍌")
 }
 これは、 item が Banana 型のときだけOK、それ以外の型はダメ！

 🍛 ちょっと実用的なジェネリクスの例
 func printDecoded<T>(from data: Data) throws -> T where T: Decodable {
     try JSONDecoder().decode(T.self, from: data)
 }
 これはこう言ってる：TはDecodableである必要があるよ（じゃないと decode() できないでしょ？）

 📦 プロトコルでの where（あなたが聞いてたやつ）
 protocol BaseRequest: Request where Response: Decodable
 これは：Request を継承してるけど、その中の Response 型は Decodable にしてね！

 ✅ まとめ
 where の使い方    意味・使いどころ
 func foo<T>() where T: Codable    T は Codable 準拠じゃないとダメ
 protocol P: Q where T: Decodable    継承元の型に制約つける
 extension Array where Element == Int    Intだけの配列に限定して拡張する
 🗣️ 例えると…
 where は「〜な人だけ入れるドア」みたいなもの。

 🟥 普通の func や protocol → どんな人でも来ていい

 🟩 where 付き → 「この条件に当てはまる人だけ入ってね！」って絞る
 */

