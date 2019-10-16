//
//  ActivityIndicator.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

///
protocol Loadable {
    func showLoading(show: Bool)
}

extension Loadable where Self: UIViewController {
    /// show or hide the activity loader
    /// - Parameter show: to decide to show or hide the activity indicator
    func showLoading(show: Bool) {
        if show {
            self.showLoading()
        } else {
            self.hideLoading()
        }
    }

    /// create an activity indicator and add it to my view and start animating
    private func showLoading() {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    /// stop animation the indicator view and remove it from the parent view
    private func hideLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        guard let firstView = self.view.subviews.filter({ type(of: $0) == UIActivityIndicatorView.self }).first,
            let progress = firstView as? UIActivityIndicatorView else { return }
        progress.stopAnimating()
        progress.removeFromSuperview()
    }
}
