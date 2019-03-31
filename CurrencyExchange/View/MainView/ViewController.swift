//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift
import EasyPeasy

class ViewController: UIViewController {
    //Dispose bag
    private let disposeBag = DisposeBag()
    
    private let txtFieldAmount: UITextField = {
        let tfd = UITextField(frame: CGRect.zero)
        tfd.keyboardType = .numberPad
        tfd.borderStyle = .roundedRect
        tfd.placeholder = "Amount"
        tfd.textAlignment = .right
        tfd.text = "1"
        return tfd
    }()
    
    private let btnDown: ButtonWithImage = {
        let btn = ButtonWithImage(type: .roundedRect)
        btn.setTitle("USD", for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.setImage(UIImage(named: "ic_arrow"), for: .normal)
        return btn
    }()
    
    private let mCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(RateCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        return cv
    }()
    
    private var refreshControl = UIRefreshControl()
    
    let currencyViewModel = CurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindingUI()
    }
    
    private func setupUI() {
        
        self.view.addSubview(txtFieldAmount)
        txtFieldAmount.easy.layout(
            Top(100),
            Left(10),
            Right(10),
            Height(40)
        )
        
        self.view.addSubview(btnDown)
        btnDown.easy.layout(
            Top(15).to(txtFieldAmount),
            Left(10),
            Right(10),
            Height(40)
        )
        mCollectionView.addSubview(refreshControl)
        self.view.addSubview(mCollectionView)
        mCollectionView.easy.layout(
            Top(25).to(btnDown),
            Left(),
            Right(),
            Bottom()
        )
    }
    
    private func bindingUI() {
        btnDown.rx.tap
            .subscribe { _ in
                self.txtFieldAmount.text = "1"
                let listVC = ListCurrenciesViewController()
                self.navigationController?.pushViewController(listVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        currentSelectCurrency
            .asObservable()
            .map { $0.keys.first }
            .bind(to: btnDown.rx.title())
            .disposed(by: disposeBag)
        
        currencyViewModel.liveCurrencies.asObservable()
            .bind(to:self.mCollectionView.rx.items(cellIdentifier: "cell", cellType: RateCollectionViewCell.self)) { (collectionView, data, cell) in
                cell.viewModelCell = RateCollectionViewCellViewModel(data.keys.first ?? "", amount: data.values.first ?? 0, cCurrency: self.btnDown.titleLabel?.text ?? "")
            }
            .disposed(by: disposeBag)
        mCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: currencyViewModel.refreshObject)
            .disposed(by: disposeBag)
        
        currencyViewModel.refreshObject
            .asObservable()
            .subscribe(onNext: { (event) in
                self.refreshControl.endRefreshing()
            }, onError: { (error) in
                self.refreshControl.endRefreshing()
            }, onCompleted: {
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        txtFieldAmount.rx.text
            .orEmpty
            .bind(to: currencyViewModel.amountCurrencies)
            .disposed(by: disposeBag)
    }
    
    
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

