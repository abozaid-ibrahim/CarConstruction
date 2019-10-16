//
//  ImageLoader.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    /// wrapper for kingfisher setImage
    /// - Parameter url: url of the image
    func setImage(with url: String?) {
        self.kf.setImage(with: URL(string: url ?? ""))
    }
}
