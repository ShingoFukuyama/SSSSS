import Foundation

@MainActor
protocol CustomObservable: ObservableObject {
    associatedtype Action
    associatedtype Mutation
    associatedtype State

    func mutate(action: Action, state: State) -> AsyncStream<Mutation>
    func reduce(state: inout State, mutation: Mutation)

    var state: State { get set }
}

extension CustomObservable {
    func send(_ action: Action) {
        // アクション発火時のStateのスナップショット
        let currentState = self.state
        Task {
            for await mutation in mutate(action: action, state: currentState) {
                reduce(state: &self.state, mutation: mutation)
            }
        }
    }
}
