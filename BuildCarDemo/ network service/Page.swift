//
//  Page.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

final class Page {
    var currentPage :Int = 0
    var maxPages :Int = 1
    var countPerPage :Int =  15
    var isFetchingData  = false
    var fetchedItemsCount = 0
    var shouldLoadMore:Bool{
        (self.currentPage < self.maxPages) &&  (!self.isFetchingData)
    }
}
protocol Pageable {
    func loadCells(for indexPaths: [IndexPath])
}
