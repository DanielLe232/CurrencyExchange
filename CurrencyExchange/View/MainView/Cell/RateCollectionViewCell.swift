//
//  RateCollectionViewCell.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift

class RateCollectionViewCell: UICollectionViewCell {
    
    let nameCurrency: UILabel = {
        let lbl = UILabel(frame: CGRect.zero)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    let amountCurrency: UILabel = {
        let lbl = UILabel(frame: CGRect.zero)
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var viewModelCell: RateCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModelCell else {
                return
            }
            let disposeBag = DisposeBag()
            viewModel.nameCurrency.asObservable()
                .map {$0}
                .bind(to: nameCurrency.rx.text)
                .disposed(by: disposeBag)
            viewModel.amount.asObservable()
                .map {$0 }
                .bind(to: amountCurrency.rx.text)
                .disposed(by: disposeBag)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 241/255, green: 242/255, blue: 246/255, alpha: 1.0)
        self.addSubview(nameCurrency)
        self.addSubview(amountCurrency)
        
        nameCurrency.easy.layout(
            Top(5),
            Left(5),
            Right(5),
            Height(17)
        )
        
        amountCurrency.easy.layout(
            Top(5).to(nameCurrency),
            Left(3),
            Right(3),
            Bottom(3)
        )
    }
    
}
