//
//  CustomView.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Combine
import SwiftUI

struct CustomView: View {
    @ObservedObject var store: CustomViewStore

    init(store: CustomViewStore) {
        self.store = store
    }

    var body: some View {
        VStack {
            Text("Count: \(store.count)")
            Button {
                store.action(.incrementCount)
            } label: {
                Text("Increment")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pink)
    }
}

final class CustomViewStore: CustomObservable {
    @Published private(set) var count = 0

    enum Action {
        case incrementCount
    }

    enum Mutation {
        case setCount(Int)
    }

    func mutate(action: Action) -> Mutation {
        switch action {
        case .incrementCount:
            return .setCount(count + 1)
        }
    }

    func reduce(mutation: Mutation) {
        switch mutation {
        case let .setCount(count):
            self.count = count
        }
    }
}

protocol CustomObservable {
    associatedtype Action
    associatedtype Mutation
    func action(_ action: Action)
    func mutate(action: Action) -> Mutation
    func reduce(mutation: Mutation)
}

extension CustomObservable {
    func action(_ action: Action) {
        let mutation = mutate(action: action)
        reduce(mutation: mutation)
    }
}
