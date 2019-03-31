//
//  BaseCurrencyModel.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import ObjectMapper

class ErrorModel: Mappable {
    
    var code: Int = 0
    var info: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["code"]
        info <- map["info"]
    }
}

class BaseCurrencyModel: Mappable {
    
    var success:    Bool = false
    var terms:      String = ""
    var privacy:    String = ""
    var error:      ErrorModel?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        success     <- map["success"]
        terms       <- map["terms"]
        privacy     <- map["privacy"]
        error       <- map["error"]
    }
}
