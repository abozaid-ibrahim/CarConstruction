//
//  ManufacturerViewController.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

/// list of manfacturers
final class ManufacturerViewController: UIViewController, Loadable {
    // MARK: Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var errorLbl: UILabel!
    @IBOutlet private var errorView: UIView!

    private let disposeBag = DisposeBag()
    var viewModel: ManufacturerViewModel!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        configuerTableView()
        bindToViewModel()
        viewModel.loadData(showLoader: true)
    }
}

// MARK: - private stuff

extension ManufacturerViewController {
    private func setTitle() {
        title = "Car Builder"
    }

    /// set tableview appearanc and register cell
    private func configuerTableView() {
        tableView.registerNib(ManufacturerTableCell.self)
        tableView.seperatorStyle()
    }

    /// bind views to viewmodel attributes to table, error handler, progress and title
    private func bindToViewModel() {
        bindTableView()
        viewModel.showProgress
            .observeOn(MainScheduler.instance)
            .bind(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.error.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        let hasError = Observable.merge(viewModel.error.filterNil().map { $0.isEmpty },
                                        viewModel.manufacturersList.filterNil().map { !$0.isEmpty })

        hasError.bind(to: errorView.rx.isHidden).disposed(by: disposeBag)
    }

    /// bind data source, and prefetch data source to the tableview
    private func bindTableView() {
        viewModel.manufacturersList
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ManufacturerTableCell.self), cellType: ManufacturerTableCell.self)) { index, model, cell in
                cell.setData(with: model.value, index: index)
            }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Manufacturer.self).bind(onNext: showCarTypesList(of:))
            .disposed(by: disposeBag)
        tableView.rx.prefetchRows.bind(onNext: viewModel.loadCells(for:)).disposed(by: disposeBag)
    }

    /// show list of cartypes for the selected manufacturer
    /// - Parameter element: selected Manufacturer
    private func showCarTypesList(of manu: Manufacturer) {
        let carModelController = ModelViewController()
        let viewModel = CarTypeViewModel(manufacturer: manu)
        carModelController.viewModel = viewModel
        navigationController?.pushViewController(carModelController, animated: true)
    }
}
