//
//  CustomObservable.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Foundation

@MainActor
protocol CustomObservable: ObservableObject {
    associatedtype Action
    associatedtype Mutation
    associatedtype State

    func send(_ action: Action)
    func mutate(action: Action) async -> [Mutation]
    func reduce(state: inout State, mutation: Mutation)

    var state: State { get set }
}

extension CustomObservable {
    func send(_ action: Action) {
        Task {
            let mutations = await mutate(action: action)
            var state = self.state
            for mutation in mutations {
                reduce(state: &state, mutation: mutation)
            }
            self.state = state
        }
    }
}
