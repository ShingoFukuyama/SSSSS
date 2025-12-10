//
//  CustomViewState.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Combine

final class CustomViewState: CustomObservable {
    @Published var state: State = .init()

    enum Action {
        case incrementCount
        case fetchPosts
    }

    enum Mutation {
        case setCount(Int)
        case setPosts([JsonPlaceholder.Post])
        case setErrorMessage(String?)
    }

    struct State {
        var count = 0
        var posts: [JsonPlaceholder.Post] = []
        var errorMessage: String?
    }

    func mutate(action: Action) async -> [Mutation] {
        switch action {
        case .incrementCount:
            [.setCount(state.count + 1)]
        case .fetchPosts:
            await fetchPosts()
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case let .setCount(count):
            state.count = count
        case let .setPosts(posts):
            state.posts = posts
        case let .setErrorMessage(errorMessage):
            state.errorMessage = errorMessage
        }
    }

    private func fetchPosts() async -> [Mutation] {
        let result = await JsonPlaceholder.fetchPosts()
        switch result {
        case let .success(posts):
            return [.setPosts(posts)]
        case let .failure(error):
            return [.setErrorMessage(error.errorDescription)]
        }
    }
}
