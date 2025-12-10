//
//  ViewController.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {
    private let viewStore = CustomViewState()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        let rootView = CustomView(store: viewStore)
        let vc = UIHostingController(rootView: rootView)
        vc.willMove(toParent: self)
        view.addSubview(vc.view)
        addChild(vc)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
    }
}

