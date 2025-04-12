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


// MARK: - 実践コード

import Foundation
import Dependencies
import DependenciesMacros

// モデル（APIレスポンスの仮モデル）

public struct WeatherResponse: Codable, Equatable, Sendable {
    public let weather: String
    public let temperature: Int
}

// ネットワーククライアントの定義

// 実際に通信するクライアント構造体（本番用やスタブに差し替え可能）
public struct NetworkClient {
    public init() {}

    public func fetchWeatherData(for city: String) async throws -> WeatherResponse {
        // 本来はここでURLSessionなどを使ってAPI通信します
        // 今回は仮データで返します
        return WeatherResponse(weather: "Sunny", temperature: 25)
    }
}

// Dependencyクライアント定義

@DependencyClient
public struct NetworkClientDependency: Sendable {
    public var fetchWeatherData: @Sendable (String) async throws -> WeatherResponse
}

// `DependencyValues`に登録
public extension DependencyValues {
    var networkClient: NetworkClientDependency {
        get { self[NetworkClientDependency.self] }
        set { self[NetworkClientDependency.self] = newValue }
    }
}

// 天気サービス

public struct WeatherService {
    @Dependency(\.networkClient) var networkClient

    public init() {}

    public func getWeather(for city: String) async throws -> String {
        let response = try await networkClient.fetchWeatherData(city)
        return "The weather in \(city) is \(response.weather) and temperature is \(response.temperature)℃"
    }
}

// アプリのエントリーポイント（例）

// @main
struct WeatherApp {
    static func main() async {
        // 本番用依存関係を登録
        DependencyValues[NetworkClientDependency.self] = NetworkClientDependency(fetchWeatherData: { (city: String) -> WeatherResponse in
            try await NetworkClient().fetchWeatherData(for: city)
        })
//        DependencyValues[NetworkClientDependency.self] = NetworkClientDependency { city in
//            try await NetworkClient().fetchWeatherData(for: city)
//        }

        let weatherService = WeatherService()

        do {
            let result = try await weatherService.getWeather(for: "Tokyo")
            print(result)  // 出力例: The weather in Tokyo is Sunny and temperature is 25℃
        } catch {
            print("エラーが発生しました: \(error)")
        }
    }
}

