//
//  CarTypeTests.swift
//  BuildCarDemoTests
//
//  Created by abuzeid on 10/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

@testable import BuildCarDemo
import Nimble
import Quick
import RxBlocking
import RxNimble
import RxOptional
import RxSwift
import RxSwiftExt
import RxTest

class CarTypeTests: QuickSpec {
    override func spec() {
        describe("Selection of Car Type") {
            context("Connection is stable and user have many results") {
                let manufacturer = ("107", "Renault")
                var viewModel: CarTypeViewModel!
                var schedular: TestScheduler!
                var carTypesObserver: TestableObserver<CarObject>!
                var disposeBag = DisposeBag()
                beforeEach {
                    viewModel = CarTypeViewModel(apiClient: MockedAPi(), manufacturer: manufacturer)
                    schedular = TestScheduler(initialClock: 0)
                    carTypesObserver = schedular.createObserver(CarObject.self)
                    disposeBag = DisposeBag()
                }
                it("set title with Renault") {
                    let title = schedular.createObserver(String.self)
                    viewModel.title.filterNil().asObservable().subscribe(title).disposed(by: disposeBag)
                    schedular.start()
                    expect(title.events).to(equal([
                        Recorded.next(0, "Renault"),
                    ]))
                }
                it("set tableview with data") {
                    viewModel.carType.filterNil().asObservable().subscribe(carTypesObserver).disposed(by: disposeBag)
                    schedular.start()
                    viewModel.loadData()
                    expect(carTypesObserver.events).to(equal([
                        Recorded.next(0, [
                            "Arnage": "Arnage",
                            "Azure": "Azure",
                            "Logan": "Logan",
                            "Megan": "Megan",
                        ]),

                    ]))
                }

                context("User Selected a car type") {
                    it("show to user string with manufacture and model") {
                        let text = schedular.createObserver(String.self)

                        viewModel.chooses.asObservable().subscribe(text).disposed(by: disposeBag)
                        schedular.start()
                        viewModel.combineSelection(with: ("Arnage", "Arnage"))
                        expect(text.events).to(equal([
                            Recorded.next(0, "Model: \(manufacturer.1)\n\("Arnage"): \("Arnage")"),
                        ]))
                    }
                }
                context("No Connection user should recive error") {
                    it("should show error to the user") {
                        let viewModel = CarTypeViewModel(apiClient: FailureMockedAPi(), manufacturer: manufacturer)

                        let errorText = schedular.createObserver(String.self)
                        viewModel.error.filterNil().asObservable().subscribe(errorText).disposed(by: disposeBag)
                        schedular.start()
                        viewModel.loadData()
                        expect(errorText.events).to(equal([
                            Recorded.next(0, NetworkFailure.failedToParseData.errorDescription!),
                        ]))

                    }
                }
            }
        }
    }
}

private class MockedAPi: ApiClient {
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
            "Logan": "Logan",
            "Megan": "Megan"

            }
            }
            """

            let data = response.data(using: .utf8)
            observer.onNext(data?.toModel())
            return Disposables.create()
        }
    }
}

private class FailureMockedAPi: ApiClient {
    func getData<T>(of _: RequestBuilder, model _: T.Type) -> Observable<T?> where T: Decodable, T: Encodable {
        return Observable<T?>.create { observer in
            observer.onError(NetworkFailure.failedToParseData)
            return Disposables.create()
        }
    }
}
