//
//  RateCollectionViewCellViewModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RateCollectionViewCellViewModel {
    
    private let disposeBag = DisposeBag()
    let nameCurrency = BehaviorSubject<String>(value: "")
    let amount = BehaviorSubject<String>(value: "")
    
    init(_ name: String, amount: Float, cCurrency: String) {
        nameCurrency.onNext(convertString(currCurrency: cCurrency, name))
        
        let st = "\(amount)"
        self.amount.onNext(st)
    }
    
    func convertString(currCurrency: String, _ currency: String) -> String {
        if let range = currency.range(of: currCurrency)?.upperBound {
            let newString = currency[range...]
            return currCurrency + " -> " + newString
        } else {
            return currency
        }
    }
    
}
