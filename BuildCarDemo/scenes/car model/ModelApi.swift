//
//  ModelApi.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

enum CarModelApi {
    case carTypes(key: String, page: Int, pageSize: Int)
}

extension CarModelApi: RequestBuilder {
    public var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    public var path: String {
        return "car-types/manufacturer"
    }
    
    var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }
    
    public var method: HttpMethod {
        return .get
    }
    
    public var task: URLRequest {
        switch self {
        case .carTypes(let prm):
            let prmDic = [
                "pageSize": prm.pageSize,
                "page": prm.page,
                "&wa_key": prm.key
            ] as [String: Any]
            var items = [URLQueryItem]()
            var myURL = URLComponents(string: endpoint.absoluteString)
            for (key, value) in prmDic {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            myURL?.queryItems = items
            
            let request = URLRequest(url: endpoint, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            return request
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
