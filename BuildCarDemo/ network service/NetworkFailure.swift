//
//  NetworkFailure.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
enum NetworkFailure: LocalizedError {
    case generalFailure, failedToParseData, connectionFailed
    var errorDescription: String? {
        switch self {
        case .failedToParseData:
            return "Technical Difficults, we can't fetch the data"
        default:
            return "Check your connectivity"
        }
    }
}
