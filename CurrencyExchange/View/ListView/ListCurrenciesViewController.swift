//
//  ListCurrenciesViewController.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift
import RxCocoa

class ListCurrenciesViewController: UIViewController {
    
    private let listCurrenciesVM = ListCurrenciesViewModel()
    private let disposeBag = DisposeBag()
    
    private let mTableview: UITableView = {
        let tbl = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tbl.showsVerticalScrollIndicator = false
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindingUI()
    }
    
    private func setupUI() {
        
        self.view.addSubview(mTableview)
        mTableview.easy.layout(
            Edges()
        )
    }
    
    private func bindingUI() {
        
        listCurrenciesVM.listCurrencies
            .asObservable()
            .bind(to: mTableview.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                cell.textLabel?.text = element.values.first
            }
            .disposed(by: disposeBag)
        
        mTableview.rx.itemSelected
            .asObservable()
            .do(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .bind(to: listCurrenciesVM.selectedIndexSubject)
            .disposed(by: disposeBag)
        
        listCurrenciesVM.errorCurrencies
            .asObserver()
            .subscribe { (error) in
                let alertController = UIAlertController(title: "\(error.element ?? "")", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
    }
    
}
