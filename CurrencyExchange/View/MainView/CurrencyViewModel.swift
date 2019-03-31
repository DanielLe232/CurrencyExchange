//
//  CurrencyViewModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift

// global
let currentSelectCurrency = PublishSubject<CurrenciesJSON>()

class CurrencyViewModel {
    
    private let disposeBag = DisposeBag()
    
    var liveCurrencies = PublishSubject<[QuotesJSON]>()
    let errorCurrencies = PublishSubject<String>()
    let amountCurrencies = BehaviorSubject<String>(value: "")
    let refreshObject = PublishSubject<Void>()
    var sourceCurrency = ""
    
    var calculateRate = [QuotesJSON]()
    let database = DatabaseManage()
    
    init() {
        
        getlist()
        currentSelectCurrency
            .asObservable()
            .subscribe({ (source) in
                self.sourceCurrency = source.element?.keys.first ?? "USD"
                self.getlist()
            })
            .disposed(by: disposeBag)
        
        refreshObject
            .asObservable()
            .flatMapLatest {
                return self.getListRateCurrency()
            }.bind(to: liveCurrencies)
            .disposed(by: disposeBag)
        
        amountCurrencies
            .asObservable()
            .map {($0 as NSString).floatValue}
            .observeOn(MainScheduler.asyncInstance)
            .subscribe({ (amount) in
                self.calculateRate(amount.element!)
            })
            .disposed(by: disposeBag)
    }
    
    private func getlist() {
        // check data exist in Database
        if let model = database.getRateCurrency(sourceCurrency) {
            // compare time
            if database.compareTime(model.timestamp) {
                getListFromAPI()
            } else {
                self.saveInObject(model.quotes.dictionaryValue() as! QuotesJSON)
            }
        } else {
            // no exist, get new list from api
            getListFromAPI()
        }
        
    }
    
    private func getListFromAPI() {
        CurrencyLiveNetwork.getLiveCurrencies(source: sourceCurrency)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response) in
                if response.success {
                    self.saveInObject(response.quotes)
                    // save with new rate model
                    self.saveDataInDB(response)
                } else {
                    if let err = response.error {
                        self.errorCurrencies.onNext(err.info)
                    }
                }
                }, onError: { [unowned self] (error) in
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
    }
    
    func saveDataInDB(_ model: CurrencyLiveModel) {
        let modelCR = ModelCurrencyRateDB()
        modelCR.quotes = (model.quotes as NSDictionary).jsonString()
        modelCR.source = model.source
        modelCR.timestamp = model.timestamp
        self.database.saveRateCurrency(modelCR, withEdit: false)
    }
    
    func saveInObject(_ quotes: QuotesJSON) {
        var arrTemp = [QuotesJSON]()
        for (key, value) in (quotes.sorted(by: <)) {
            print("\(key) \(value)")
            let dic = QuotesJSON(dictionaryLiteral: (key, value))
            arrTemp.append(dic)
        }
        self.liveCurrencies.onNext(arrTemp)
        self.calculateRate = arrTemp
    }
    
    func getListRateCurrency() -> Observable<[QuotesJSON]> {
        return liveCurrencies
    }
    
    func calculateRate(_ amount: Float32) {
        print("calculate")
        var arrTemp = [QuotesJSON]()
        for element in calculateRate {
            let newRate = multiple2Number(element.values.first!, amount)
            arrTemp.append(QuotesJSON(dictionaryLiteral: (element.keys.first!, newRate)))
        }
        self.liveCurrencies.onNext(arrTemp)
    }
    
    func multiple2Number(_ number1: Float32, _ number2: Float32) -> Float32 {
        return number1 * number2
    }
    
}
