//
//  CurrencyLiveNetwork.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift

class CurrencyLiveNetwork: BaseNetwork {
    static func getLiveCurrencies(source: String) -> Observable<CurrencyLiveModel> {
        return requestJson(network: .liveCurrencies(source: source))
    }
}
