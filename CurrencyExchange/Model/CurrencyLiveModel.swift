//
//  CurrencyLiveModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrencyLiveModel: BaseCurrencyModel {
    
    var timestamp:  Float32 = 0.0
    var source:     String = ""
    var quotes:     QuotesJSON = [:]
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        timestamp   <- map["timestamp"]
        source      <- map["source"]
        quotes      <- map["quotes"]
    }
}
