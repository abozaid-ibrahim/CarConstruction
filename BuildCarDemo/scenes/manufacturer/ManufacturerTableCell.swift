//
//  ManufacturerTableCell.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class ManufacturerTableCell: UITableViewCell {
    @IBOutlet private var modelNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(with model: String, index: Int) {
        modelNameLbl.text = model
        backgroundColor = index.evenOddColorBase()
    }
}
