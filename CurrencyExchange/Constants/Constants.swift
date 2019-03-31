//
//  Constants.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit

typealias QuotesJSON        = [String: Float32]
typealias CurrenciesJSON    = [String: String]

enum APIErrorCode: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    
    var description: String {
        switch self {
        case .forbidden:
            return "Forbidden error"
        case .notFound:
            return "Not found error"
        case .conflict:
            return "Conflict error"
        case .internalServerError:
            return "There is no connection"
        }
    }
}

struct Constants {
    
    static let K_TIME = 30 * 60
    //The API's base URL
    static let baseUrl = "https://apilayer.net/api/"
    
    // API Key
    static let apiKey = ""
    
    // Access Key
    static let accessKey = "?access_key=\(apiKey)"
}
