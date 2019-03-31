//
//  CurrencyListModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrencyListModel: BaseCurrencyModel {
    
    var currencies: CurrenciesJSON?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        currencies <- map["currencies"]
    }
}
