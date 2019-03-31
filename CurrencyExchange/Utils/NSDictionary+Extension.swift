//
//  NSDictionary+Extension.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit

extension NSDictionary {
    
    func jsonString() -> String
    {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String.init(data: jsonData, encoding: .utf8)!
        }
        catch
        {
            return "error converting"
        }
    }
}
