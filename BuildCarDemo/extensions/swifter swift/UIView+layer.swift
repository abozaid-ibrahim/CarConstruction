//
//  UIView+layer.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    /// set the view to be circle and set a white border to it
    func circle() {
        layer.cornerRadius = min(bounds.height, bounds.width) / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
        layer.masksToBounds = true
    }
}
