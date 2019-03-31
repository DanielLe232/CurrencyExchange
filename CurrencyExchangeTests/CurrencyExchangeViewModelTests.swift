//
//  CurrencyExchangeViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class CurrencyExchangeViewModelTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = CurrencyViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        viewModel = nil
        super.tearDown()
    }
    
    func testSuccessWithMultipleNumberFloat() {
        let number1: Float32 = 2.0
        let number2: Float32 = 0.256
        
        XCTAssertEqual(viewModel.multiple2Number(number1, number2), 0.512, "Multiple 2 number")
    }
    
    func testSuccessCompareTime() {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate - 10
        
        XCTAssertTrue(viewModel.database.compareTime(Float(timestamp)))
    }
    
    func testFailCompareTime() {
        // need change when test again www.epochconverter.com
        let timestamp = 1553937032000
        
        XCTAssertFalse(viewModel.database.compareTime(Float(timestamp)))
    }
    
    func testSuccessConvertJsonToModel() {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let json = [
            "success"   :   false,
            "terms"     :   "",
            "privacy"   :   "",
            "timestamp" :   timestamp,
            "source"    :   "USD",
            "quotes"    :   [
                "USDAED": 3.672982,
                "USDAFN": 57.8936,
                "USDALL": 126.1652,
                "USDAMD": 475.306
            ]
            ] as [String : Any]
        
        XCTAssertNotNil(CurrencyLiveModel(JSON: json))
    }
    
    func testSuccessSaveDataInDB() {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let json = [
            "timestamp" :   timestamp,
            "source"    :   "USD",
            "quotes"    :   [
                "USDAED": 3.672982,
                "USDAFN": 57.8936,
                "USDALL": 126.1652,
                "USDAMD": 475.306
            ]
            ] as [String : Any]
        guard let model = CurrencyLiveModel(JSON: json) else {
            XCTFail()
            return
        }
        
        viewModel.saveDataInDB(model)
        XCTAssertNotNil(viewModel.database.getRateCurrency("USD"))
    }
    
    func testSuccessSaveObject() {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let json = [
            "timestamp" :   timestamp,
            "source"    :   "USD",
            "quotes"    :   [
                "USDAED": 3.672982,
                "USDAFN": 57.8936,
                "USDALL": 126.1652,
                "USDAMD": 475.306
            ]
            ] as [String : Any]
        guard let model = CurrencyLiveModel(JSON: json) else {
            XCTFail()
            return
        }
        viewModel.saveInObject(model.quotes)
        XCTAssertNotNil(viewModel.calculateRate)
        XCTAssertNotNil(viewModel.liveCurrencies)
    }
}
