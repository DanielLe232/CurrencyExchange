//
//  DatabaseManage.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import UIKit
import RxSwift
import RxCocoa
import RealmSwift

final class DatabaseManage {
    
    init() {
        
    }
    
    func saveRateCurrency(_ model: ModelCurrencyRateDB, withEdit edit: Bool) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(model, update: edit)
        }
    }
    
    func getRateCurrency(_ source: String) -> ModelCurrencyRateDB? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "source = %@",source)
        let list = realm.objects(ModelCurrencyRateDB.self).filter(predicate)
        return list.first ?? nil
    }
    
    // true is more than Constants.K_TIME and otherwise
    func compareTime(_ otherTime: Float) -> Bool {
        let givenDate = Date(milliseconds: otherTime)
        let diff = Date().minutes(from: givenDate)
        if diff > Constants.K_TIME {
            return true
        }
        return false
    }
}
