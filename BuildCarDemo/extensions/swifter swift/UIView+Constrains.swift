//
//  UIView+Constrains.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// set the constrains of subview to it's parent view
    /// - Parameter insets: the margin needed between the view and i'ts subview
    func equalToSuperViewEdges(insets: UIEdgeInsets = .zero) {
        guard let parent = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom).isActive = true
    }
}
