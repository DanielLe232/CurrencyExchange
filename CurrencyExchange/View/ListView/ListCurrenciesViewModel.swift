//
//  ListCurrenciesViewModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift

final class ListCurrenciesViewModel {
    
    private let disposeBag = DisposeBag()
    
    // for search
    var tempCurrencies  = PublishSubject<[CurrenciesJSON]>()
    
    let listCurrencies  = PublishSubject<[CurrenciesJSON]>()
    let errorCurrencies = PublishSubject<String>()
    let selectedIndexSubject = PublishSubject<IndexPath>()
    
    init() {
        
        // get list
        CurrencyListNetwork.getListCurrencies()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response) in
                if response.success {
                    var arrTemp = [CurrenciesJSON]()
                    for (key, value) in (response.currencies?.sorted(by: <))! {
                        print("\(key) \(value)")
                        let dic = CurrenciesJSON(dictionaryLiteral: (key, value))
                        arrTemp.append(dic)
                    }
                    self.listCurrencies.onNext(arrTemp)
                } else {
                    if let err = response.error {
                        self.errorCurrencies.onNext(err.info)
                    }
                }
                }, onError: { [unowned self](error) in
                    var strError = ""
                    switch error {
                    case APIErrorCode.conflict:
                        strError = APIErrorCode.conflict.description
                    case APIErrorCode.forbidden:
                        strError = APIErrorCode.forbidden.description
                    case APIErrorCode.notFound:
                        strError = APIErrorCode.notFound.description
                    case APIErrorCode.internalServerError:
                        strError = APIErrorCode.internalServerError.description
                    default:
                        strError = "Unknown error: \(error.localizedDescription)"
                    }
                    self.errorCurrencies.onNext(strError)
            })
            .disposed(by: disposeBag)
        
        
        // select row
        self.selectedIndexSubject
            .asObservable()
            .withLatestFrom(listCurrencies){
                (indexPath, currency) in
                return currency[indexPath.item]
            }
            .map { $0 }
            .bind(to: currentSelectCurrency)
            .disposed(by: disposeBag)
    }
}
