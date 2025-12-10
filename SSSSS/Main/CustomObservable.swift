import Foundation

enum Observable<T> {
    case just(T)
    case async(() async -> T)
    case concat([Observable<T>])
}

@MainActor
protocol CustomObservable: ObservableObject {
    associatedtype Action
    associatedtype Mutation: Sendable
    associatedtype State

    func send(_ action: Action)
    func mutate(action: Action) async -> Observable<Mutation>
    func reduce(state: inout State, mutation: Mutation)

    var state: State { get set }
}

extension CustomObservable {
    func send(_ action: Action) {
        Task {
            let mutation = await mutate(action: action)
            var state = self.state
            await run(state: &state, observable: mutation)
            self.state = state
        }
    }

    private func run(state: inout State, observable: Observable<Mutation>) async {
        switch observable {
        case let .just(mutation):
            reduce(state: &state, mutation: mutation)

        case let .async(task):
            // update self.state before async
            self.state = state
            let mutation = await task()
            reduce(state: &state, mutation: mutation)

        case let .concat(observables1):
            for observable1 in observables1 {
                switch observable1 {
                case .just, .async:
                    await run(state: &state, observable: observable1)

                case let .concat(observables2):
                    for observable2 in observables2 {
                        await run(state: &state, observable: observable2)
                    }
                }
            }
        }
    }
}
