//
//  Bindable.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/03.
//

// MARK: - @Bindable

/*
 https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.7/#BindingState
 
 @Bindableプロパティラッパーの解説
 @Bindable は、Composable Architecture（TCA）における新しいプロパティラッパーで、ビューからストア（Store）に直接アクセスするために使用されます。このラッパーを使うことで、従来の WithViewStore を使う必要がなくなり、より簡潔にバインディングを作成できます。

 1. @Bindableの目的
 従来、TCAではビューからストアの状態を参照するために WithViewStore コンポーネントを使い、ViewStore を経由して状態を取得する方法が一般的でした。しかし、@Bindable を使うことで、ビューからストアに直接アクセスできるようになり、コードが簡潔になります。

 例えば、以下のように使用します。

 @Bindable var store: StoreOf<Feature>
 これにより、store をビューで直接使用できるようになります。StoreOf<Feature> は、Feature というリデューサーに基づくストアで、その状態（State）を管理します。

 2. バインディングの方法
 @Bindable を使うと、ビュー側で状態を直接バインディングできるようになります。例えば、以下のようなコードになります。

 var body: some View {
   Form {
     TextField("Text", text: $store.text)  // 直接バインディング
     Toggle(isOn: $store.isOn)             // 直接バインディング
   }
 }
 ここで、$store.text や $store.isOn として、ストアの状態（text と isOn）に直接アクセスしているため、WithViewStore を使ってビューの状態を取得していた従来の方法に比べて、コードが非常にシンプルで直感的になります。

 3. 古いAppleプラットフォームでの対応
 @Bindableは古いバージョンのAppleプラットフォームをターゲットにしている場合、@Bindable をそのまま使うことができません。

 その場合、@Perception.Bindable というバックポートされたプロパティラッパーを使用することで、同じようにストアをバインディングできるようになります。

 @Perception.Bindable var store: StoreOf<Feature>
 これを使うことで、@Bindable が使えない古いAppleプラットフォームでも、同じようにストアにアクセスし、バインディングを作成することができます。

*/
