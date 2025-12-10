import UIKit
import Combine

final class AAViewController: UIViewController {
    private let viewStore = CustomViewState()

    private var cancellables = Set<AnyCancellable>()

    private lazy var countLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        label.text = "Count: 0"
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCountLabel))
        label.addGestureRecognizer(tap)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        view.addSubview(countLabel)
        countLabel.center = CGPoint(x: view.center.x, y: 100)

        bindViewState()
    }

    private func bindViewState() {
        viewStore.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                // Example: update UI
                if let label = self.view.subviews.compactMap({ $0 as? UILabel }).first {
                    label.text = "Count: \(state.count)"
                }
            }
            .store(in: &cancellables)
    }

    @objc private func didTapCountLabel() {
        viewStore.send(.incrementCount)
    }
}
