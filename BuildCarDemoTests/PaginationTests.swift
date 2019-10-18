//
//  BuildCarDemoTests.swift
//  BuildCarDemoTests
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//
@testable import BuildCarDemo

import RxOptional
import RxSwift
import RxSwiftExt
import RxTest
import XCTest

class PaginationTests: XCTestCase {
    private var viewModel: ManufacturersListViewModel!
    private var apiClient: ApiClient!
    private let disposeBag = DisposeBag()
    private var manufacturersObserver: TestableObserver<Manufacturers>!
    private var schedular: TestScheduler!
    override func setUp() {
        apiClient = MockedAPi()
        viewModel = ManufacturersListViewModel(apiClient: apiClient)
        schedular = TestScheduler(initialClock: 0)
        manufacturersObserver = schedular.createObserver(Manufacturers.self)
    }
    
    override func tearDown() {
        viewModel = .none
        apiClient = .none
    }
    
    func testGettinDataOfTwoPages() {
        viewModel.manufacturersList.asObservable().unwrap().subscribe(manufacturersObserver).disposed(by: disposeBag)

        viewModel.loadData()
        schedular.start()
        XCTAssertTrue(manufacturersObserver.events.contains { eve in
            eve.value.element!.count == 6
        })
        viewModel.loadCells(for: [IndexPath(item: 20, section: 0)])
       XCTAssertTrue(self.manufacturersObserver.events.contains { eve in
        eve.value.element!.count == 12
                  })
        
        
    }
}

private class MockedAPi: ApiClient {
    let page0 = """
    {
    "page": 0,
    "pageSize": 6,
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
    let page1 = """
    {
    "page": 1,
    "pageSize": 6,
    "totalPageCount": 2,
    "wkda": {
    "Arnage1": "Arnage1",
    "Azure1": "Azure1",
    "Continental Flying Spur1": "Continental Flying Spur1",
    "Continental GT1": "Continental GT1",
    "Continental GTC1": "Continental GTC1",
    "Continental SC1": "Continental SC1"
    }
    }
    """
    func getData<T>(of request: RequestBuilder, model: T.Type) -> Observable<T?> where T: Decodable, T: Encodable {
        return Observable<T?>.create { observer in
            var response = ""
            if case let ManufacturerApi.manufacturers(value) = request {
                response = value.page == 0 ? self.page0 : self.page1
            }
            let data = response.data(using: .utf8)
            observer.onNext(data?.toModel())
            return Disposables.create()
        }
    }
}
