//
//  NetworkLayer.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import Moya

enum NetworkLayer {
    case listCurrencies
    case liveCurrencies(source: String)
    case convertCurrencies(from: String, to: String, amount: Float32)
}

extension NetworkLayer: TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .listCurrencies:
            return "list\(Constants.accessKey)"
        case .liveCurrencies(let source):
            return "live\(Constants.accessKey)&source=\(source)"
        case .convertCurrencies(let from, let to, let amount):
            return "convert\(Constants.accessKey)&from=\(from)&to=\(to)&amount=\(amount) "
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
}
