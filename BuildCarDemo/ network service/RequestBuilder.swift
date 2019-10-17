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

public enum HttpMethod:String {
    case get, post
}

struct APIConstants {
    static let baseURL = "http://api-aws-eu-qa-1.auto1-test.com/v1/"
    static let authKey = "coding-puzzle-client-449cc9d"
    static let timeout = Double(30)
}
