//
//  SongsViewModel.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift
typealias ManufacturerModel = (key: String, value: String)
protocol CarModelViewModel {}

/// viewModel of songs list,
final class ModelViewModel: CarModelViewModel {
    private let disposeBag = DisposeBag()
    private let apiClient: ApiClient
    private var page = 1
    private let countPerPage = 15
    private var mainTypes: Manufacturer = [:]
    private var manu: ManufacturerModel!
    private var isFetchingData = false
    var fetchedItemsCount = 0

    // MARK: Observers

    var car = BehaviorSubject<Manufacturer?>(value: .none)
    var showProgress = PublishSubject<Bool>()
    var error = PublishSubject<String?>()
    var manufacturer = BehaviorSubject<ManufacturerModel?>(value: .none)
    var chooses = PublishSubject<String>()

    /// initializier
    /// - Parameter apiClient: network handler
    init(apiClient: ApiClient = HTTPClient(), manufacturer: ManufacturerModel) {
        self.apiClient = apiClient
        self.manu = manufacturer
        self.manufacturer.onNext(manufacturer)
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
        let api = CarApi.mainTypes(key: APIConstants.authKey, manufacturer: self.manu.key, page: self.page, pageSize: self.countPerPage)
        self.apiClient.getCarTypeData(of: api)
            .filterNil()
            .subscribe(onNext: { [unowned self] response in
                self.mainTypes = response.wkda ?? [:]
                self.fetchedItemsCount = self.mainTypes.values.count
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
        self.car.onNext(self.mainTypes)
    }

    func combineSelection(with type: CarType) {
        let text = "Model: \(manu.value)\n\(type.key):\(type.value)"

        self.chooses.onNext(text)
    }
}
