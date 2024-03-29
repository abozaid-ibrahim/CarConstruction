//
//  UITableView+Cell.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    /// wrapper to register cell in a short line
    /// - Parameter name: the cell identifier
    func registerNib(_ name: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: name.self), bundle: .none),
                 forCellReuseIdentifier: String(describing: name.self))
    }

    /// set the cell seperator style and remove it from the empty cells
    func seperatorStyle() {
        separatorStyle = .singleLine
        tableFooterView = UIView()
    }
}
