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

    /// fill ui with it's model
    /// - Parameter icon: song artwork
    /// - Parameter name: song title
    /// - Parameter auther: auther name
    /// - Parameter duration: duration of the song
    func setData(with type: CarType, index: Int) {
        self.keyLbl.text = type.0
        self.valueLbl.text = type.1
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
