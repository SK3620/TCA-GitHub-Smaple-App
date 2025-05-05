//
//  CasePaths.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture
import CasePaths

// MARK: - KeyPath
// KeyPathの基本的な使い方 参考リンク⬇︎
// https://zenn.dev/ueshun/articles/8c968b0fcda506

struct Song {
    var title: String
    var artist: Artist
    var albumArtwork: UIImage
}

struct Artist {
    var name: String
}

// ① 基本
let song = Song(title: "Let it Be", artist: Artist(name: "Beatles"), albumArtwork: UIImage(systemName: "square.and.arrow.up")!)
let titlekeyPath: KeyPath<Song, String> = \.title
// let titlekeyPath2: KeyPath<Song, String> = \Song.title // この書き方もありだが、型を明示しないとビルド通らない?
print(song[keyPath: titlekeyPath]) // Let it Be

// ② ネストしたプロパティにアクセスしたい場合
let song = Song(title: "Let it Be", artist: Artist(name: "Beatles"), albumArtwork: UIImage(systemName: "square.and.arrow.up")!)
let artistKeyPath: KeyPath<Song, Artist> = \.artist
let nameKeyPath: KeyPath<Artist, String> = \.name
let artistNameKeyPath = artistKeyPath.appending(path: nameKeyPath)
print(song[keyPath: artistNameKeyPath]) // Beatles

// ③「②」をさらに簡潔に
let song = Song(title: "Let it Be", artist: Artist(name: "Beatles"), albumArtwork: UIImage(systemName: "square.and.arrow.up")!)
let artistNameKeyPath: KeyPath<Song, String> = \Song.artist.name
print(song[keyPath: artistNameKeyPath]) // Beatles


// MARK: - CasePathsライブラリ
// 列挙型の特定のケースとその関連値にアクセス・変更するための仕組み

// MARK: - 基礎
enum HomeAction {
    case onAppear
}

enum SettingsAction {
    case open
}

enum UserAction {
    case home(HomeAction)
    case settings(SettingsAction)
}

// \UserAction.Cases.home      // CaseKeyPath<UserAction, HomeAction> === \.home（型が明示されている場合）
// \UserAction.Cases.settings  // CaseKeyPath<UserAction, SettingsAction> === \.settings（型が明示されている場合）

let userAction: UserAction = .home(.onAppear)

print(userAction[case: \.home])  // Optional(HomeAction.onAppear)
print(userAction[case: \.settings])  // nil（マッチしない場合は nil）

// MARK: - 埋め込み

// 以下のように、CasePath（KeyPath）を間接的に持っておいて、それを使用して、enumを生成できる
let userActionToHome: CasePath<UserAction, HomeAction> = \UserAction.Cases.home
let action = userActionToHome(.onAppear)

// 普通の enum の書き方だと：
let action = UserAction.home(.onAppear)
// と書くのと同じこと。

// MARK: - ケースの一致をチェックする .is メソッド

print(userAction.is(\.home))      // true
print(userAction.is(\.settings))  // false

// MARK: - パスの合成

// KeyPathの場合
struct HighScore {
    var user: User
    
    struct User {
        var id: Int
        var name: String
    }
}

let highScoreToUser = \HighScore.user
let userToName = \User.name
let highScoreToUserName = highScoreToUser.append(path: userToName)

var score = HighScore(user: User(name: "Alice"))
print(score[keyPath: highScoreToUserName])  // "Alice"

// CasePathの場合
enum AppAction {
    case user(UserAction)
}

let appActionToUser: CasePath<AppAction, UserAction> = \AppAction.Cases.user
let userActionToHome: CasePath<UserAction, HomeAction> = \UserAction.Cases.home
let appActionToHome = appActionToUser.append(path: userActionToHome)

let action = AppAction.user(.home(.onAppear))
print(action[case: appActionToHome])  // Optional(HomeAction.onAppear)

