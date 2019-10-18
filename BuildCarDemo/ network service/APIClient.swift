//
//  APIClient.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift
protocol ApiClient {
    func getData<T: Codable>(of request: RequestBuilder, model: T.Type) -> Observable<T?>
}

/// api handler, wrapper for the Url session
final class HTTPClient: ApiClient {
    private let disposeBag = DisposeBag()
    func getData<T: Codable>(of request: RequestBuilder, model _: T.Type) -> Observable<T?> { return excute(request).map { $0?.toModel() }
    }

    /// fire the http request and return observable of the data or emit an error
    /// - Parameter request: the request that have all the details that need to call the remote api
    private func excute(_ request: RequestBuilder) -> Observable<Data?> {
        return Observable<Data?>.create { (observer) -> Disposable in
            URLSession.shared.dataTask(with: request.task) { data, response, error in
                log(.info, request, response, data?.toString, error)
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200 ... 299).contains(httpResponse.statusCode) else {
                    observer.onError(NetworkFailure.generalFailure)
                    return
                }
                print(String(data: data!, encoding: .utf8) ?? "")
                observer.onNext(data)
            }.resume()
            return Disposables.create()
        }
        .share(replay: 0, scope: .forever)
    }
}

extension Data {
    func toModel<T: Decodable>() -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            print(">>> parsing error \(error)")
            return nil
        }
    }

    var toString: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

enum NetworkFailure: Error {
    case generalFailure, failedToParseData, connectionFailed
    var localizedDescription: String {
        switch self {
        case .failedToParseData:
            return "Technical Difficults, we can't fetch the data"
        default:
            return "Check your connectivity"
        }
    }
}
