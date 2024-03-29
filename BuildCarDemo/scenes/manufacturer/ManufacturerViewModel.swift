//
//  FeedViewModel.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift

protocol ManufacturerViewModel: Pageable {
    func loadData(showLoader: Bool)
    var showProgress: PublishSubject<Bool> { get }
    var error: PublishSubject<String?> { get }
    var manufacturersList: BehaviorSubject<Manufacturers?> { get }
}

final class ManufacturersListViewModel: ManufacturerViewModel {
    // MARK: private state

    private var page = Page()
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var manfacturers: Manufacturers = [:]

    // MARK: Observers

    var manufacturersList = BehaviorSubject<Manufacturers?>(value: .none)
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<String?>()

    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    /// load the data from the endpoint
    /// - Parameter showLoader: show indicator on screen to till user data is loading
    func loadData(showLoader: Bool = true) {
        guard page.shouldLoadMore else {
            return
        }
        showLoader ? showProgress.onNext(true) : ()
        page.isFetchingData = true
        let api = ManufacturerApi.manufacturers(key: APIConstants.authKey, page: page.currentPage, pageSize: page.countPerPage)
        apiClient.getData(of: api, model: ManufacturersJsonResponse.self)
            .subscribe(onNext: { [unowned self] response in
                guard let response = response else {
                    self.error.onNext(NetworkFailure.failedToParseData.errorDescription ?? "")
                    return
                }
                self.updateUIWithData(showLoader, response: response)
                self.updatePageValues(response)
            }, onError: { err in
                self.error.onNext(err.localizedDescription)
            }).disposed(by: disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithData(_ showLoader: Bool, response: ManufacturersJsonResponse) {
        showLoader ? showProgress.onNext(false) : ()
        guard let wka = response.wkda else {
            return
        }
        manfacturers.append(dict: wka)
        manufacturersList.onNext(manfacturers)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updatePageValues(_ response: ManufacturersJsonResponse) {
        page.fetchedItemsCount = manfacturers.values.count
        page.isFetchingData = false
        page.currentPage += 1
        page.maxPages = response.totalPageCount ?? 0
    }
}

// MARK: Pagination logic

extension ManufacturersListViewModel {
    /// load nearest cells in table view
    /// - Parameter indexPaths: the indexes that will appear to the user soon.
    func loadCells(for indexPaths: [IndexPath]) {
        if indexPaths.contains(where: shouldLoadMoreData(for:)) {
            loadData(showLoader: false)
        }
    }

    /// should load more items
    /// - Parameter indexPath: nearest unvisible indexpath
    private func shouldLoadMoreData(for indexPath: IndexPath) -> Bool {
        return (indexPath.row + 10) >= page.fetchedItemsCount
    }
}
