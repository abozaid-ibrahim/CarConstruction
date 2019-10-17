//
//  ManufacturerViewController.swift
//  BuildCarDemo
//
//  Created by abuzeid on 10/16/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxSwift
import UIKit

/// list of artists
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

// MARK: - UITableViewDataSourcePrefetching

private extension ManufacturerViewController {
    private func setTitle() {
        title = "Car Builder"
    }

    private func configuerTableView() {
        tableView.prefetchDataSource = self
        tableView.registerNib(ManufacturerTableCell.self)
        tableView.seperatorStyle()
    }

    /// bind views to viewmodel attributes
    private func bindToViewModel() {
        viewModel.showProgress
            .observeOn(MainScheduler.instance)
            .bind(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.manufacturersList
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ManufacturerTableCell.self), cellType: ManufacturerTableCell.self)) { index, model, cell in
                cell.setData(with: model.value,index:index)
            }.disposed(by: disposeBag)
        tableView.rx.modelSelected(ManufacturerModel.self).bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.error.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
        viewModel.error.map { $0 == nil }.bind(to: errorView.rx.isHidden).disposed(by: disposeBag)
    }

    /// show list of songs for spacific arist
    /// - Parameter element: list of songs for the artist
    private func showSongsList(element: ManufacturerModel) {
        let carModelController = ModelViewController()
        let songsViewModel = ModelViewModel(manufacturer: element)
        carModelController.viewModel = songsViewModel
        navigationController?.pushViewController(carModelController, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ManufacturerViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.loadData(showLoader: false)
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.fetchedItemsCount
    }
}
