//
//  CarModelViewModel.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol CarModelViewModel: Pageable {
    func loadData(showLoader: Bool)
    func combineSelection(with type: CarType)
    var carType: BehaviorSubject<CarObject?> { get }
    var showProgress: PublishSubject<Bool> { get }
    var error: PublishSubject<String?> { get }
    var title: BehaviorSubject<String?> { get }
    var chooses: PublishSubject<String> { get }
}

/// viewModel of cartypes list,
final class CarTypeViewModel: CarModelViewModel {
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = Page()
    private var manufacturer: Manufacturer
    private var carTypes: Manufacturers = [:]

    // MARK: Observers

    var carType = BehaviorSubject<CarObject?>(value: .none)
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<String?>()
    var title = BehaviorSubject<String?>(value: .none)
    var chooses = PublishSubject<String>()

    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient(), manufacturer: Manufacturer) {
        self.apiClient = apiClient
        self.manufacturer = manufacturer
        title.onNext(manufacturer.value)
    }

    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool = true) {
        guard page.shouldLoadMore else {
            return
        }
        page.isFetchingData = true
        showLoader ? showProgress.onNext(true) : ()
        let api = CarApi.mainTypes(key: APIConstants.authKey, manufacturer: manufacturer.key, page: page.currentPage, pageSize: page.countPerPage)
        apiClient.getData(of: api, model: CarTypeJsonResponse.self)
            .subscribe(onNext: { [unowned self] response in
                guard let response = response else {
                    self.error.onNext(NetworkFailure.failedToParseData.errorDescription ?? "")
                    return
                }
                self.setUIWithData(showLoader, response: response)
                self.updatePageValues(response)
            }, onError: { err in
                self.error.onNext(err.localizedDescription)
            }).disposed(by: disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updatePageValues(_ response: CarTypeJsonResponse) {
        page.maxPages = response.totalPageCount ?? 0
        page.fetchedItemsCount = response.wkda?.values.count ?? 0
        page.currentPage += 1
        page.isFetchingData = false
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func setUIWithData(_ showLoader: Bool, response: CarTypeJsonResponse) {
        carTypes.append(dict: response.wkda ?? [:])
        carType.onNext(carTypes)
        if showLoader {
            showProgress.onNext(false)
        }
    }

    /// combine user model selection with car type
    /// - Parameter type: current car type selected from table view
    func combineSelection(with type: CarType) {
        let text = "Model: \(manufacturer.value)\n\(type.key): \(type.value)"
        chooses.onNext(text)
    }
}

// MARK: Pagination logic

extension CarTypeViewModel {
    /// load nearest cells in table view
    /// - Parameter indexPaths: the indexes that will appear to the user soon.
    func loadCells(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: shouldLoadMoreData) {
            loadData(showLoader: false)
        }
    }

    /// should load more items
    /// - Parameter indexPath: nearest unvisible indexpath
    private func shouldLoadMoreData(for indexPath: IndexPath) -> Bool {
        return (indexPath.row + 10) >= page.fetchedItemsCount
    }
}
