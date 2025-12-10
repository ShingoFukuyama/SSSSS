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

    func mutate(action: Action, state: State) -> AsyncStream<Mutation> {
        AsyncStream { continuation in
            // 副作用とロジックはバックグランドスレッドで行う
            let task = Task.detached { [weak self] in
                defer {
                    continuation.finish()
                }

                guard let self else { return }
                
                switch action {
                case .incrementCount:
                    continuation.yield(.setCount(state.count + 1))
                    
                case .fetchPosts:
                    continuation.yield(.setIsLoading(true))
                    let resultAction = await self.fetchPosts()
                    continuation.yield(resultAction)
                    continuation.yield(.setIsLoading(false))
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
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

    // MainActorのコンテキストから切り離し、不要なメインスレッド占有とStateへの書き込みを防ぐ
    private nonisolated func fetchPosts() async -> Mutation {
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
