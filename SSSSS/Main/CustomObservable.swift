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
    func send(_ action: Action)
    func mutate(action: Action) async -> [Mutation]
    func reduce(mutation: Mutation)
}

extension CustomObservable {
    func send(_ action: Action) {
        Task {
            let mutations = await mutate(action: action)
            for mutation in mutations {
                reduce(mutation: mutation)
            }
        }
    }
}
