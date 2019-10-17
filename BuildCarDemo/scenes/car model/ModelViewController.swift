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

final class ModelViewController: UIViewController, Loadable {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: ModelViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        binding()
        viewModel.loadData(showLoader: true)
    }

    /// set table view style and reigster cells
    private func configureTableView() {
        tableView.registerNib(ModelTableCell.self)
        tableView.seperatorStyle()
    }

    /// bind ui attributes to view model state variables for example, title, and datasource
    private func binding() {
        viewModel.showProgress
            .observeOn(MainScheduler.instance)
            .bind(onNext: showLoading(show:)).disposed(by: disposeBag)

        viewModel.manufacturer.filterNil().map { $0.value }.bind(to: rx.title).disposed(by: disposeBag)
        let id = String(describing: ModelTableCell.self)
        viewModel.car
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: id, cellType: ModelTableCell.self)) { index, model, cell in
                cell.setData(with: model, index: index)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(CarType.self).bind(onNext: viewModel!.combineSelection(with:)).disposed(by: disposeBag)
        viewModel.chooses.bind(onNext: showChoices(choices:)).disposed(by: disposeBag)
        tableView.rx.prefetchRows.subscribe(onNext: { [unowned self] _ in

        }).disposed(by: disposeBag)
    }

    private func showChoices(choices: String) {
        let alert = UIAlertController(title: "Your choices ", message: choices, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
