//
//  AppCoordinator.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    /// Starts the coordinator
    ///
    /// - Parameter completion: completion handler called after the coordinator has started
    func start(completion: (() -> Void)?)
    /// Finishes the coordinator
    ///
    /// - Parameter completion: completion handler called after the coordinator has finished
    func finish(completion: (() -> Void)?)
}

extension Coordinator {
    func start() {
        start(completion: nil)
    }

    func finish() {
        finish(completion: nil)
    }
}

/// The App Coordinator creates the The Root ViewController of the Window
final class AppCoordinator: Coordinator {
    weak var window: UIWindow?

    private(set) var rootNavigationController: UINavigationController?

    /// Creates a new instance of the App Coordinator
    ///
    /// - Parameter window: The main widnow of the application
    init(window: UIWindow?) {
        self.window = window
    }

    func start(completion: (() -> Void)?) {
        guard let window = self.window else { completion?(); return }
        let main = ManufacturerViewController()
        main.viewModel = ManufacturersListViewModel()
        rootNavigationController = UINavigationController(rootViewController: main)
        window.rootViewController = rootNavigationController
        completion?()
    }

    func finish(completion: (() -> Void)?) {
        completion?()
    }
}
