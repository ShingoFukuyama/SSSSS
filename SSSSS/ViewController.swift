import SwiftUI
import UIKit

final class ViewController: UIViewController {
    private let viewStore = CustomViewState()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        setupCustomView()
        // setupAAView()
    }

    private func setupCustomView() {
        let rootView = CustomView(store: viewStore)
        let vc = UIHostingController(rootView: rootView)
        vc.willMove(toParent: self)
        view.addSubview(vc.view)
        addChild(vc)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }

    private func setupAAView() {
        let vc = AAViewController()
        vc.willMove(toParent: self)
        view.addSubview(vc.view)
        addChild(vc)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
}
