//
//  DictionaryExtension.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
extension Dictionary {
    mutating func append(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
