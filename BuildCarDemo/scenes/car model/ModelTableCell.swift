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

    @IBOutlet private var songImgView: UIImageView!
    @IBOutlet private var songNameLbl: UILabel!
    @IBOutlet private var autherLbl: UILabel!
    @IBOutlet private var durationLbl: UILabel!

    /// fill ui with it's model
    /// - Parameter icon: song artwork
    /// - Parameter name: song title
    /// - Parameter auther: auther name
    /// - Parameter duration: duration of the song
    func setData(_ icon: String?, name: String?, auther: String?, duration: String?) {
        self.songImgView.setImage(with: icon)
        self.autherLbl.text = auther
        self.songNameLbl.text = name
        self.durationLbl.text = duration
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .blue
        self.songImgView.circle()
    }
}
