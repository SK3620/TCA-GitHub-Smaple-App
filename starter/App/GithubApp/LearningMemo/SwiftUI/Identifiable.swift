//
//  Identifiable.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/03/30.
//

// MARK: - Identifable
/*
 Identifiable, Equatable をつける意味
 Identifiable とは？
 Identifiable をつけることで、SwiftUI の ForEach などのリスト表示コンポーネントが id を使って要素を一意に識別できるようになります。

 なぜ Identifiable をつけるの？
 たとえば、リストを表示するときに SwiftUI の ForEach を使うとします。

 struct RepositoryListView: View {
     let items: [RepositoryItem]

     var body: some View {
         List(items) { item in
             Text(item.name)
         }
     }
 }
 ここで RepositoryItem が Identifiable を持っていないと、SwiftUI はどの要素がどのリスト項目に対応するのかわかりません。id を使って要素を識別できるようにするために、Identifiable をつけます。

 つまり Identifiable をつけると id で識別できるようになり、SwiftUI のリストなどで使いやすくなる！


 */
