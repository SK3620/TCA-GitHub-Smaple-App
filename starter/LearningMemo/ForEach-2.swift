//
//  ForEach-2.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/18.
//

//🍌ざっくり言うと何？
//.forEach(\., action: \.) {} は、
//
//「配列の中の一個一個のアイテムにも、それぞれ専用の処理（＝ロジック Reducer）を割り当てたいときに使う魔法の仕組み」
//
//🍎たとえば現実の例で言うと？
//「注文管理アプリ」を作ってるとしよう
//
//注文が複数ある → orders という配列で持ってる
//
//各注文には個別の処理（削除ボタン、ステータス変更など）がある
//
//つまりこういう状態：

struct OrderFeature {
    struct State {
        var orders: IdentifiedArrayOf<Order.State>
    }

    enum Action {
        case orders(IdentifiedActionOf<Order>)
    }
}
//このときに、それぞれの注文に対して「個別の小さなロジック（Reducer）」を適用したい！
//
//そんなときに使うのが…
//
//✨ .forEach(\.orders, action: \.orders) { Order() }
//意味を分解すると：
//
//
//\.orders    状態（State）の中の orders という配列を見に行く
//action: \.orders    アクション（Action）の中の orders に関係するものを拾う
//{ Order() }    各注文に対して、どの処理（Reducer）を適用するかを書く

//「親が持ってる配列の中の1個ずつに、ちゃんと処理を当てたいときの便利機能」
//「TCAでリストっぽいものを扱うときの基本技」

