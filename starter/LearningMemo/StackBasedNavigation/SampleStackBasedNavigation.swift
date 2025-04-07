//
//  SampleStackBasedNavigation.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/04/07.
//

// TCAの基本インポート
import ComposableArchitecture
import SwiftUI

// 各子Featureを定義
@Reducer
struct AddFeature {
  @ObservableState
  struct State {}
  enum Action {}
  var body: some Reducer<State, Action> {
    Reduce { state, action in .none }
  }
}

@Reducer
struct DetailFeature {
  @ObservableState
  struct State {}
  enum Action {}
  var body: some Reducer<State, Action> {
    Reduce { state, action in .none }
  }
}

@Reducer
struct EditFeature {
  @ObservableState
  struct State {}
  enum Action {
    case saveButtonTapped
  }
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .saveButtonTapped:
        return .none
      }
    }
  }
}

// RootFeature
@Reducer
struct RootFeature {
  @Reducer
  enum Path {
    case addItem(AddFeature)
    case detailItem(DetailFeature)
    case editItem(EditFeature)
  }

  @ObservableState
    struct State: Equatable {
    var path = StackState<Path.State>()
  }

  enum Action {
    case path(StackActionOf<Path>)
    case addButtonTapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.path.append(.addItem(AddFeature.State()))
        return .none

      case let .path(.element(id: id, action: .editItem(.saveButtonTapped))):
        state.path.pop(from: id)
        return .none

      case .path:
        return .none
      }
    }
    .forEach(\ .path, action: \ .path)
  }
}

// 各子画面
struct AddView: View {
  let store: StoreOf<AddFeature>
  var body: some View {
    Text("Add View")
  }
}

struct DetailView: View {
  let store: StoreOf<DetailFeature>
  var body: some View {
    Text("Detail View")
  }
}

struct EditView: View {
  let store: StoreOf<EditFeature>
  var body: some View {
    VStack {
      Text("Edit View")
      Button("Save") {
        store.send(.saveButtonTapped)
      }
    }
  }
}

// RootView
struct RootView: View {
    @Perception.Bindable var store: StoreOf<RootFeature>

  var body: some View {
    NavigationStack(
      path: $store.scope(state: \ .path, action: \ .path)
    ) {
      VStack {
        Button("Add") {
          store.send(.addButtonTapped)
        }
        NavigationLink(state: RootFeature.Path.State.detailItem(DetailFeature.State())) {
          Text("Go to Detail")
        }
        NavigationLink(state: RootFeature.Path.State.editItem(EditFeature.State())) {
          Text("Go to Edit")
        }
      }
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

// アプリのエントリーポイント
// @main
struct StackNavigationApp: App {
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(initialState: RootFeature.State()) {
          RootFeature()
        }
      )
    }
  }
}

