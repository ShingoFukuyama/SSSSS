//
//  CustomObservable.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Foundation

protocol CustomObservable: ObservableObject {
    associatedtype Action
    associatedtype Mutation
    func action(_ action: Action)
    func mutate(action: Action) async -> [Mutation]
    func reduce(mutation: Mutation)
}

extension CustomObservable {
    func action(_ action: Action) {
        Task {
            let mutations = await mutate(action: action)
            for mutation in mutations {
                reduce(mutation: mutation)
            }
        }
    }
}
