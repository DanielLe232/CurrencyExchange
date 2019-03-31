//
//  BaseNetwork.swift
//  CurrencyExchange
//
//  Created by MacOS on 3/30/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Moya_ObjectMapper
import ObjectMapper

class BaseNetwork {
    
    static let myEndpointClosure = { (target: NetworkLayer) -> Endpoint in
        let url = target.baseURL.absoluteString + target.path
        //http://XXXX/api/xlogin.ashx?action=xulogin
        //This method will escape special characters
        //let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        //http://XXXX/api/xlogin.ashx%3Faction=xulogin
        let endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        //Set up your header information
        return endpoint.adding(newHTTPHeaderFields: [:])
    }
    
    static let provider = MoyaProvider<NetworkLayer>(endpointClosure: myEndpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])
    
    static func requestJson<T: Mappable>(network: NetworkLayer) -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            let request = provider.request(network, completion: { (response) in
                switch response.result {
                case .success(let response):
                    do {
                        let repos = try response.mapObject(T.self)
                        observer.onNext(repos)
                        observer.onCompleted()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    switch response.result.value?.statusCode {
                    case 403:
                        observer.onError(APIErrorCode.forbidden)
                    case 404:
                        observer.onError(APIErrorCode.notFound)
                    case 409:
                        observer.onError(APIErrorCode.conflict)
                    case 500:
                        observer.onError(APIErrorCode.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            })
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
