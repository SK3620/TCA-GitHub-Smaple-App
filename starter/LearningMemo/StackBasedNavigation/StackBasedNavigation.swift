//
//  StackBasedNavigation.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/07.
//

/*
 🧰 基本の登場人物たち
 Composable Architecture（TCA）では、以下の3つが中核になります：

 名前    役割
 StackState    今、積み重なっている画面状態のリスト（＝スタックそのもの）
 StackAction    スタックに追加・削除したり、各画面のアクションをやりとりするもの
 NavigationStack    SwiftUIの見た目を担う、画面の積み重ねを表現するUI部品
 📦 実装の流れ（猿にもわかるステップで）
 ① どんな画面を積めるか「Path」として定義する
 @Reducer
 struct RootFeature {
   @Reducer
   enum Path {
     case addItem(AddFeature)
     case detailItem(DetailFeature)
     case editItem(EditFeature)
   }
 }
 ここでは「追加・詳細・編集」という3種類の画面を積み重ねられるよって教えてる。

 ② スタックの状態とアクションを持つ
 @Reducer
 struct RootFeature {
   @ObservableState
   struct State {
     var path = StackState<Path.State>()
   }

   enum Action {
     case path(StackActionOf<Path>)
   }
 }
 path →
 今積み上がっている画面の状態たち（「今どの画面が積み上がってるかを全部メモしてる箱」）
 例えば、path = [DetailViewの状態, EditViewの状態] → 詳細 → 編集 まで積まれてる
 
 path(StackActionOf<Path>) →
 子画面からのイベントを受け取る窓口
 これは、子どもの画面（AddViewとかDetailViewとか）からイベントが来たときに受け取る窓口だよ。
 🧪 たとえば…
 編集画面（EditView）で「保存」ボタンを押した
 詳細画面（DetailView）で「削除」ボタンを押した
 ⬇️
 これらの「ユーザーの操作（アクション）」が、path(StackActionOf<Path>) に届く！

 ③ 各子画面の処理を親とつなげる .forEach を使う
 var body: some ReducerOf<Self> {
   Reduce { state, action in
     // 親のロジック
   }
   .forEach(\.path, action: \.path)
 }
 親は path に対して .forEach で子のイベントを拾えるようにする。
 親にイベントを伝えられるよう、子供達みんなに親に電話できる受話器を渡しておくイメージ
 

 ④ SwiftUIの画面を作る（NavigationStack）
 struct RootView: View {
   @Bindable var store: StoreOf<RootFeature>

   var body: some View {
     NavigationStack(
       path: $store.scope(state: \.path, action: \.path)
     ) {
       // スタックの一番下（ホーム画面）
     } destination: { store in
       switch store.case {
       case .addItem(let store):
         AddView(store: store)
       case .detailItem(let store):
         DetailView(store: store)
       case .editItem(let store):
         EditView(store: store)
       }
     }
   }
 }
 path: には状態とアクションのスコープを渡す
 destination →
 「積み上がった状態（path）の中身を見て、それに合う画面を表示するよ」
 
 
 ⑥ NavigationStack(
   path: $store.scope(state: \.path, action: \.path)
 )って？
 🧩 store.scope(state: \.path, action: \.path) の意味
 🐵 これ、何をしてるの？
 → **「store の中から、path という状態（state）とアクション（action）だけを取り出す」**ってこと！

 🧠 より詳しく！
 store は、TCA で使う 状態（State） と アクション（Action） を管理している「箱」のようなもの。
 でも NavigationStack に渡すには、その中の一部の情報（path）だけを取り出して渡す必要があるんだよ。
 だから、store.scope(state: \.path, action: \.path) は：
 「store の中から path の部分だけを取り出して、NavigationStack で使える形にする」って意味！

 🔑 ポイント
 state: \.path → これは store の中にある状態のうち、path だけを取り出すってこと。
 action: \.path → これは store の中のアクションのうち、path に関連するものだけを取り出すってこと。
 
 ここでいうpathとは↓
 path は、どの画面が現在表示されているか、どの画面から遷移してきたか などを スタック（積み重ね）として記録している状態だよ。
 たとえば、ユーザーが画面を遷移するときに、画面遷移の情報（どこに行ったか、何を見ているか）を path に積み上げていく感じ。

 
 🧭 画面を積み上げる方法（Push）
 ✅ 方法①: NavigationLink で積む
 NavigationLink(
   state: RootFeature.Path.State.detailItem(DetailFeature.State())
 ) {
   Text("詳細を見る")
 }
 → これをタップすると自動で .push(id:state:) が送られて、スタックに追加される。新しい画面（例えばDetail画面）を path に積み上げる

 デメリット：この方法だと Path.State にアクセス必要なので、画面の独立性が低くなる（モジュール分割しにくい）

 ✅ 方法②: ボタンでアクション送って積む
 Button("詳細へ") {
   store.send(.detailButtonTapped)
 }
 そして親のReducerで…
 case .detailButtonTapped:
   state.path.append(.detailItem(DetailFeature.State()))
   return .none
 → よりモジュールごとの責務が明確で、テストしやすい✨

 🔁 子画面から親へ通知（Integration）
 親は .path(.element(id:action)) という形で子画面のアクションを監視できる。

 case let .path(.element(id: id, action: .editItem(.saveButtonTapped))):
   guard let editItemState = state.path[id: id]?.editItem else { return .none }

   state.path.pop(from: id)
   return .run { _ in
     await self.database.save(editItemState.item)
   }
 つまり、親が子のアクションをちゃんと拾って処理できる。
 
 case let .path →
 これは、path の状態が変更されたときに呼ばれるパターンマッチング。
 pathの中にある特定の画面（element）で「保存ボタンがタップされた」というアクションが発生した場合の処理。


 👋 子画面を閉じる（Dismiss）
 ✅ 方法①: SwiftUIの .dismiss() を使う（View層）
 struct ChildView: View {
   @Environment(\.dismiss) var dismiss

   var body: some View {
     Button("閉じる") {
       dismiss()
     }
   }
 }
 Viewだけで完結するけど、バリデーションなど複雑なロジックは書けない。

 ✅ 方法②: TCAの @Dependency(\.dismiss) を使う（Reducer層）
 @Dependency(\.dismiss) var dismiss

 case .closeButtonTapped:
   return .run { _ in await self.dismiss() }
 自動で .popFrom(id:) を送信してくれる

 Reducerから書けるので、ロジック含めて閉じられる！

 ⚠️ dismiss後にアクション送るのはNG！

 🎯 StackState vs NavigationPath（純正）
 NavigationPath はSwiftUI純正のナビゲーションの状態管理。

 StackState は Composable Architecture向けに作られた拡張バージョン で、アクションやIDの管理がしやすい。TCAを使うなら基本 StackState を使おう！

 ✅ まとめ：Stack-based navigation のメリット
 状態（State）として画面遷移を表現できる

 深い遷移も柔軟に対応

 各画面の状態をしっかり管理・テストできる

 TCAの型システムと相性抜群
*/
