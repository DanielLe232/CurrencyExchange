//
//  Results+Extension.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
