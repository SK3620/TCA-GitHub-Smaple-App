//
//  Binding.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/05.
//

import ComposableArchitecture
import SwiftUI

// MARK: - 手動でバインディング（Ad hoc bindings）
//  TCAでは、SwiftUIの@Stateや@Bindingのような仕組みを「状態とアクションを明示的に定義してつなぐ」ことで実現します。

@Reducer
struct SettingsManual {
    
    @ObservableState
    struct State: Equatable {
        var isHapticsEnabled = true
    }
    
    enum Action {
        case isHapticsEnabledChanged(Bool)
    }
    
    var body: some ReducerOf<Self>  {
        Reduce { state, action in
            switch action {
            case let .isHapticsEnabledChanged(isEnabled):
                state.isHapticsEnabled = isEnabled
                return .none
            }
        }
    }
}

struct SettingsManualView: View {
  @Bindable var store: StoreOf<SettingsManual>

  var body: some View {
    Form {
      Toggle(
        "Haptic feedback",
        isOn: $store.isHapticsEnabled.sending(\.isHapticsEnabledChanged)
      )
    }
  }
}

// 注意：古いOS対応（iOS 16 未満など）の場合は @Perception.Bindable を使う
// @Perception.Bindable var store: StoreOf<SettingsManual> に置き換え


// MARK: - 自動バインディング（BindableAction + BindingReducer）

@Reducer
struct SettingsAuto {
  @ObservableState
  struct State: Equatable {
    var displayName = ""
    var enableNotifications = false
    var protectMyPosts = false
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    // 必要に応じて追加ロジックを Reduce や onChange で拡張可能
    Reduce { state, action in
      switch action {
      case .binding(\.displayName):
        // 例: バリデーション処理
        return .none

      case .binding(\.enableNotifications):
        // 例: 通知許可リクエスト処理
        return .none

      default:
        return .none
      }
    }
  }
}

struct SettingsAutoView: View {
  @Bindable var store: StoreOf<SettingsAuto>

  var body: some View {
    Form {
      TextField("Display name", text: $store.displayName)
      Toggle("通知を有効にする", isOn: $store.enableNotifications)
      Toggle("投稿を保護する", isOn: $store.protectMyPosts)
    }
  }
}

// MARK: - onChangeを使った拡張（リアクション処理）

@Reducer
struct SettingsAutoWithChange {
  @ObservableState
  struct State: Equatable {
    var displayName = ""
    var enableNotifications = false
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
      .onChange(of: \.displayName) { old, new in
        // 例: 名前のバリデーション処理
      }
      .onChange(of: \.enableNotifications) { old, new in
        // 例: 通知許可処理のトリガー
      }
  }
}

