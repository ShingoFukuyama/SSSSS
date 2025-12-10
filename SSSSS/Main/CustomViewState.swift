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

    enum Mutation: Sendable {
        case setCount(Int)
        case setIsLoading(Bool)
        case setPosts([JsonPlaceholder.Post])
        case setErrorMessage(String?)
    }

    struct State {
        var count = 0
        var isLoading = false
        var posts: [JsonPlaceholder.Post] = []
        var errorMessage: String?
    }

    func mutate(action: Action) async -> Observable<Mutation> {
        switch action {
        case .incrementCount:
            return .just(.setCount(state.count + 1))
        case .fetchPosts:
            return .concat([
                .just(.setIsLoading(true)),
                .async(fetchPosts()),
                .just(.setIsLoading(false))
            ])
        }
    }

    func reduce(state: inout State, mutation: Mutation) {
        switch mutation {
        case let .setCount(count):
            state.count = count
        case let .setIsLoading(isLoading):
            state.isLoading = isLoading
        case let .setPosts(posts):
            state.posts = posts
        case let .setErrorMessage(errorMessage):
            state.errorMessage = errorMessage
        }
    }

    private func fetchPosts() -> () async -> Mutation {
        {
            try? await Task.sleep(for: .seconds(1))
            let result = await JsonPlaceholder.fetchPosts()
            switch result {
            case let .success(posts):
                return .setPosts(posts)
            case let .failure(error):
                return .setErrorMessage(error.errorDescription)
            }
        }
    }
}
