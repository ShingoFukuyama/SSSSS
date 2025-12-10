//
//  CustomViewState.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import Combine

final class CustomViewState: CustomObservable {
    @Published private(set) var count = 0
    @Published private(set) var posts: [JsonPlaceholder.Post] = []
    @Published private(set) var errorMessage: String?

    enum Action {
        case incrementCount
        case fetchPosts
    }

    enum Mutation {
        case setCount(Int)
        case setPosts([JsonPlaceholder.Post])
        case setErrorMessage(String?)
    }

    func mutate(action: Action) async -> [Mutation] {
        switch action {
        case .incrementCount:
            return [.setCount(count + 1)]
        case .fetchPosts:
            return await fetchPosts()
        }
    }

    func reduce(mutation: Mutation) {
        switch mutation {
        case let .setCount(count):
            self.count = count
        case let .setPosts(posts):
            self.posts = posts
        case let .setErrorMessage(errorMessage):
            self.errorMessage = errorMessage
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
