//
//  ManufacturerTableCell.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

final class ManufacturerTableCell: UITableViewCell {
    @IBOutlet private var artistImgView: UIImageView!
    @IBOutlet private var aristNameLbl: UILabel!
    @IBOutlet private var songsCountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        artistImgView.circle()
    }

    func setData(with model: Manufacturer) {
//        artistImgView.setImage(with: model.avatarUrl)
//        aristNameLbl.text = model.username
//        songsCountLbl.text = String(model.songsCount)
    }
}
