//
//  CurrencyListNetwork.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift

class CurrencyListNetwork: BaseNetwork {
    
    static func getListCurrencies() -> Observable<CurrencyListModel> {
        return requestJson(network: .listCurrencies)
    }
}
