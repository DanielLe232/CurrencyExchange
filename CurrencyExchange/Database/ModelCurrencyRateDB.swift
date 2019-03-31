//
//  ModelCurrencyRateDB.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RealmSwift

class ModelCurrencyRateDB: Object {
    @objc dynamic var timestamp:  Float32 = 0.0
    @objc dynamic var source:     String = ""
    @objc dynamic var quotes:     String = "" //it will convert to QuotesJSON
}
