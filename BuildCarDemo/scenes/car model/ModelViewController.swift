//
//  SongsViewController.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxOptional
import RxSwift
import UIKit

final class ModelViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: ModelViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        binding()
    }

    /// set table view style and reigster cells
    private func configureTableView() {
        tableView.registerNib(ModelTableCell.self)
        tableView.seperatorStyle()
    }

    /// bind ui attributes to view model state variables for example, title, and datasource
    private func binding() {
        viewModel.manufacturer.filterNil().map { "\($0)" }.bind(to: rx.title).disposed(by: disposeBag)
        let id = String(describing: ModelTableCell.self)
//        viewModel.spacificationList
//            .filterNil()
//            .bind(to: tableView.rx.items(cellIdentifier: id,
//                                         cellType: ModelTableCell.self)) { _, _, _ in
////                cell.setData(model.artworkUrl,
////                             name: model.title,
////                             auther: model.user?.username,
////                             duration: (model.duration ?? ""))
//            }.disposed(by: disposeBag)

//        tableView.rx.itemSelected.bind(onNext: viewModel!.playSong(index:)).disposed(by: disposeBag)
    }
}
