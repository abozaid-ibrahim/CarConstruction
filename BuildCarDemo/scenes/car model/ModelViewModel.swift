//
//  SongsViewModel.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

protocol CarModelViewModel {}

/// viewModel of songs list,
final class ModelViewModel: CarModelViewModel {
    private let disposeBag = DisposeBag()
    var spacificationList = BehaviorSubject<CarTypeJsonResponse?>(value: .none)
    var manufacturer = BehaviorSubject<Manufacturer?>(value: .none)

    init(manufacturer: Manufacturer) {
        self.manufacturer.onNext(manufacturer)
    }
}

extension String {
    /// convert string to formated duration
    var songDurationFormat: String {
        guard let seconds = Int(self) else {
            return String(format: "%02d:%02d:%02d", 0, 0, 0)
        }
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
