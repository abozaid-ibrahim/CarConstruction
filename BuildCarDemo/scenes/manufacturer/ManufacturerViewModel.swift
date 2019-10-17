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

protocol ManufacturerViewModel {
    func loadData(showLoader: Bool)
    var showProgress: PublishSubject<Bool> { get }
    var error: PublishSubject<String?> { get }
    var manufacturersList: BehaviorSubject<Manufacturer?> { get }
    var fetchedItemsCount: Int { get }
}

final class ManufacturersListViewModel: ManufacturerViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = 1
    private let countPerPage = 15
    private var manfacturers: Manufacturer = [:]
    private var isFetchingData = false
    var fetchedItemsCount = 0

    // MARK: Observers

    var manufacturersList = BehaviorSubject<Manufacturer?>(value: .none)
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
        if self.isFetchingData {
            return
        }
        self.isFetchingData = true
        if showLoader {
            self.showProgress.onNext(true)
        }
        let api = ManufacturerApi.manufacturers(key: APIConstants.authKey, page: self.page, pageSize: self.countPerPage)
        self.apiClient.getData(of: api)
            .filterNil()
            .subscribe(onNext: { [unowned self] response in

                self.manfacturers = response.wkda ?? [:]
                self.fetchedItemsCount  = self.manfacturers.values.count
                self.updateUIWithData(showLoader)
            }, onError: { err in
                self.error.onNext(err.localizedDescription)
            }).disposed(by: self.disposeBag)
    }

    /// emit values to ui to fill the table view if the data is a littlet reload untill fill the table
    private func updateUIWithData(_ showLoader: Bool) {
        if showLoader {
            self.showProgress.onNext(false)
        }
        self.isFetchingData = false
        self.page += 1
        self.manufacturersList.onNext(self.manfacturers)
    }
}
