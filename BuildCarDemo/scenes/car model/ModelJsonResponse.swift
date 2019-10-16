//
//  CarTypeJsonResponse.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
struct CarTypeJsonResponse: Codable {
    public let page: Int?
    public let pageSize: Int?
    public let totalPageCount: Int?
    public let wkda: [String: String]?

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case totalPageCount
        case wkda
    }

    public init(page: Int?, pageSize: Int?, totalPageCount: Int?, wkda: [String: String]?) {
        self.page = page
        self.pageSize = pageSize
        self.totalPageCount = totalPageCount
        self.wkda = wkda
    }
}
