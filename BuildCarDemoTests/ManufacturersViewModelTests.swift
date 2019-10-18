//
//  ManufacturersViewModelTests.swift
//  BuildCarDemoTests
//
//  Created by abuzeid on 10/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//
@testable import BuildCarDemo

import RxOptional
import RxSwift
import RxSwiftExt
import RxTest
import XCTest
class ManufacturersViewModelTests: XCTestCase {
    private var viewModel: ManufacturersListViewModel!
    private var apiClient: ApiClient!
    private let disposeBag = DisposeBag()
    private var manufacturers: TestableObserver<Manufacturers>!
    private var schedular: TestScheduler!
    override func setUp() {
        apiClient = MockedAPi()
        viewModel = ManufacturersListViewModel(apiClient: apiClient)
        schedular = TestScheduler(initialClock: 0)
        manufacturers = schedular.createObserver(Manufacturers.self)
    }

    override func tearDown() {
        viewModel = .none
        apiClient = .none
    }

    func testManipulateDataFromDifferentLayers() {
        viewModel.manufacturersList.asObservable().unwrap().subscribe(manufacturers).disposed(by: disposeBag)
        viewModel.loadData()
        schedular.start()
        XCTAssertTrue(manufacturers.events.contains { eve in
            eve.value.element?.count == 6
        })
    }
}

fileprivate class MockedAPi: ApiClient {
    func getData<T>(of _: RequestBuilder, model _: T.Type) -> Observable<T?> where T: Decodable, T: Encodable {
        return Observable<T?>.create { observer in
            let response = """
            {
            "page": 0,
            "pageSize": 25,
            "totalPageCount": 2,
            "wkda": {
            "Arnage": "Arnage",
            "Azure": "Azure",
            "Continental Flying Spur": "Continental Flying Spur",
            "Continental GT": "Continental GT",
            "Continental GTC": "Continental GTC",
            "Continental SC": "Continental SC"
            }
            }
            """

            let data = response.data(using: .utf8)
            observer.onNext(data?.toModel())
            return Disposables.create()
        }
    }
}
