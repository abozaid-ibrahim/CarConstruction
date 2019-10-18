//
//  CarTypeTests.swift
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
import Nimble
import Quick

class CarTypeTests: QuickSpec {
    override func spec() {
        print(">>>spec() \(#function)")
        describe("describe no 0 ") {
            print(">>>describe 0")
            beforeEach {
                print(">>>describe 0 -> beforeEach")
            }
            it("it00") {
                print(">>>describe 0 -> it0")
            }
            it("it1") {
                print(">>>describe 0 -> it1")
            }
            context("when the call convertDataUnit() method") {
                print(">>>describe 0 -> context")
                it("it0") {
                    print(">>>describe 0 -> context 0 -> it0")
                }
                it("it1") {
                    print(">>>describe 0 -> context 0 -> it1")
                }
            }
            context("2") {
                print(">>>describe 0 -> context1")
                it("it0") {
                    print(">>>describe 0 -> context 1 -> it0")
                }
                it("it1") {
                    print(">>>describe 0 -> context 1 -> it1")
                }
            }
        }
    }
}
