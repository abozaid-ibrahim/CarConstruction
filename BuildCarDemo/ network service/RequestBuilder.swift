//
//  RequestBuilder.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

public protocol RequestBuilder {
    var baseURL: URL { get }

    var path: String { get }

    var method: HttpMethod { get }

    var task: URLRequest { get }

    var headers: [String: String]? { get }
}

public enum HttpMethod: String {
    case get, post
}

