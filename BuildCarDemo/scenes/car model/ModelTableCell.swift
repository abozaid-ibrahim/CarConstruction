//
//  ModelTableCell.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class ModelTableCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet private var keyLbl: UILabel!
    @IBOutlet private var valueLbl: UILabel!

    
    /// Description
    /// - Parameter type: type description
    /// - Parameter index: index description
    func setData(with type: CarType, index: Int) {
        self.keyLbl.text = type.key
        self.valueLbl.text = type.value
        self.backgroundColor = index.evenOddColorBase()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
    }
}

extension Int {
    func evenOddColorBase() -> UIColor {
        return self % 2 == 0 ? UIColor.green.withAlphaComponent(0.1) : UIColor.groupTableViewBackground
    }
}
