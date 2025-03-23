//swift-tools-version: 6.0
import PackageDescription

// https://appdev-room.com/swift-package-manager
// Apple製でオープンソースなパッケージ管理ツール
// 公開されているさまざまなパッケージ(ライブラリ)依存関係を保ちつつインストールや更新、削除することが可能

// このプロジェクトがどんなライブラリや機能（ターゲット）を持っていて、それぞれが何に依存しているのかを決める
// GithubAppのパッケージを定義します
let package = Package(
    name: "GithubApp", // パッケージの名前
    platforms: [.iOS(.v16)], // サポートされる最小プラットフォームバージョン
    products: [
        // productsでは、このパッケージが生成するライブラリ（モジュール）を定義します
        // パッケージの「外」に公開するライブラリを決める場所
        // .library(name: "〇〇", targets: ["〇〇"]) で、外から使える機能だけを指定する
        
        // 🔹 name: "SharedModel" → ライブラリの名前（外部から使うときの名前）
        // 🔹 targets: ["SharedModel"] → どのターゲットの機能を公開するか？
        
        // それぞれのファイルで、import SharedModel, import ApiClientなどを定義して使用できる
        // productに定義されていないものは使えない

        .library(name: "SharedModel", targets: ["SharedModel"]), // 共有モデルライブラリ
        .library(name: "SearchRepositoriesFeature", targets: ["SearchRepositoriesFeature"]), // リポジトリ検索機能
        .library(name: "RepositoryDetailFeature", targets: ["RepositoryDetailFeature"]), // リポジトリ詳細表示機能
        .library(name: "ApiClient", targets: ["ApiClient"]), // APIクライアントライブラリ
        .library(name: "GithubClient", targets: ["GithubClient"]), // GitHub APIと対話するためのクライアント
        .library(name: "GithubClientLive", targets: ["GithubClientLive"]) // Githubクライアントのライブ実装
    ],
    dependencies: [
        // 外部パッケージの依存関係
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.5.0"), // 状態管理のためのコンポーザブルアーキテクチャ
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.2"), // 依存関係管理
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0") // API呼び出しのためのネットワーキングライブラリ
    ],
    targets: [
        // パッケージのターゲットを定義します
        .target(
            name: "SharedModel", // 共有モデルのターゲット
            dependencies: [
                // このターゲットには依存関係はありません
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        ),
        .target(
            name: "SearchRepositoriesFeature", // リポジトリ検索機能のターゲット
            dependencies: [
                "SharedModel", // 共有モデルに依存
                "GithubClient", // Githubクライアントに依存
                "RepositoryDetailFeature", // リポジトリ詳細機能に依存
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture") // コンポーザブルアーキテクチャTCAにも依存
                // これにより、状態管理やアプリケーションの構造を簡潔に保つことができます。
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        ),
        .testTarget(
            name: "SearchRepositoriesFeatureTests", // リポジトリ検索機能のテストターゲット
            dependencies: [
                "SearchRepositoriesFeature", // リポジトリ検索機能に依存
                "RepositoryDetailFeature" // リポジトリ詳細機能にも依存
                // テストを行うために、実際の機能に依存する必要があります。
            ]
        ),
        .target(
            name: "RepositoryDetailFeature", // リポジトリ詳細機能のターゲット
            dependencies: [
                "SharedModel", // 共有モデルに依存
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture") // コンポーザブルアーキテクチャを使用
                // 状態管理を行うために必要です。
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        ),
        .target(
            name: "ApiClient", // APIクライアントのターゲット
            dependencies: [
                "SharedModel", // 共有モデルに依存
                .product(name: "APIKit", package: "APIKit") // ネットワーキングのためにAPIKitを使用
                // API呼び出しを行うためのライブラリです。
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        ),
        .target(
            name: "GithubClient", // Githubクライアントのターゲット
            dependencies: [
                "SharedModel", // 共有モデルに依存
                .product(name: "Dependencies", package: "swift-dependencies"), // 依存関係管理を使用
                .product(name: "DependenciesMacros", package: "swift-dependencies") // 依存関係マクロを使用
                // これにより、依存関係の管理が簡単になります。
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        ),
        .target(
            name: "GithubClientLive", // Githubクライアントのライブ実装
            dependencies: [
                "SharedModel", // 共有モデルに依存
                "ApiClient", // APIクライアントに依存
                "GithubClient", // Githubクライアントに依存
                .product(name: "Dependencies", package: "swift-dependencies"), // 依存関係管理を使用
                .product(name: "APIKit", package: "APIKit") // ネットワーキングのためにAPIKitを使用
                // ライブ環境でのAPI呼び出しを行うために必要です。
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete" // 厳格な並行性チェックを有効にします
                    // このオプションにより、すべての非同期コードが厳格にチェックされ、潜在的な競合状態を防ぎます。
                ])
            ]
        )
    ]
)

// swift-tools-version: 5.8
// swift-tools-versionは、このパッケージをビルドするために必要なSwiftの最小バージョンを宣言します。

/*
import PackageDescription

let package = Package(
    name: "GithubApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]), // アプリ機能のためのライブラリを定義します
    ],
    targets: [
        .target(
            name: "AppFeature") // アプリ機能のターゲット
    ]
)
 */

// swift-tools-version: 5.8
// swift-tools-versionは、このパッケージをビルドするために必要なSwiftの最小バージョンを宣言します。
