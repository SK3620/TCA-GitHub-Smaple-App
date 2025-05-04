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

        .library(name: "SharedModel", targets: ["SharedModel"]),
        .library(name: "SearchRepositoriesFeature", targets: ["SearchRepositoriesFeature"]),
        .library(name: "RepositoryDetailFeature", targets: ["RepositoryDetailFeature"]),
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
        .target(
            name: "SharedModel",
            dependencies: [],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "SearchRepositoriesFeature",
            dependencies: [
                "SharedModel",
                "GithubClient",
                "RepositoryDetailFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .testTarget(
            name: "SearchRepositoriesFeatureTests",
            dependencies: [
                "SearchRepositoriesFeature",
                "RepositoryDetailFeature"
            ]
        ),
        .target(
            name: "RepositoryDetailFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "ApiClient",
            dependencies: [
                "SharedModel",
                .product(name: "APIKit", package: "APIKit")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "GithubClient",
            dependencies: [
                "SharedModel",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "GithubClientLive",
            dependencies: [
                "SharedModel",
                "ApiClient",
                "GithubClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "APIKit", package: "APIKit")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
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
