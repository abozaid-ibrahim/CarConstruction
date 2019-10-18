//
//  ModelViewController.swift
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
    var viewModel: CarModelViewModel!
    
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
        
        viewModel.title.filterNil().bind(to: rx.title).disposed(by: disposeBag)
        viewModel.chooses.bind(onNext: showChoices(choices:)).disposed(by: disposeBag)
        bindTablViewData()
    }
    
    /// set tableview data source, prefetch data source, and delegate
    private func bindTablViewData(){
        let id = String(describing: ModelTableCell.self)
        viewModel.carType
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: id, cellType: ModelTableCell.self)) { index, model, cell in
                cell.setData(with: model, index: index)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CarType.self).bind(onNext: viewModel!.combineSelection(with:)).disposed(by: disposeBag)
        
        tableView.rx.prefetchRows.bind(onNext: viewModel.loadCells(for:)).disposed(by: disposeBag)
    }
    /// show combined user selections model and cartype in alert view
    /// - Parameter choices: formatted string for use selections of the car and model
    private func showChoices(choices: String) {
        let alert = UIAlertController(title: "Your choices ", message: choices, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
