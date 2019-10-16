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

    private let disposeBag = DisposeBag()
    var viewModel: ManufacturerViewModel!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuerTableView()
        bindToViewModel()
        viewModel.loadData(showLoader: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching

private extension ManufacturerViewController {
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
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ManufacturerTableCell.self), cellType: ManufacturerTableCell.self)) { _, model, cell in
                cell.setData(with: model)
            }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Manufacturer.self).bind(onNext: showSongsList(element:)).disposed(by: disposeBag)
        viewModel.error.map { $0.localizedDescription }.bind(to: errorLbl.rx.text).disposed(by: disposeBag)
    }

    /// show list of songs for spacific arist
    /// - Parameter element: list of songs for the artist
    private func showSongsList(element: Manufacturer) {
        //        let songsView = ModelView()
        //        let songsViewModel = ModelViewModel(songs: element)
        //        songsView.viewModel = songsViewModel
        //        navigationController?.pushViewController(songsView, animated: true)
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
        return true // indexPath.row >= viewModel.currentCount
    }
}
