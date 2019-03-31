//
//  RateCollectionViewCellViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by MacOS on 3/31/19.
//  Copyright © 2019 DanielLe. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class RateCollectionViewCellViewModelTests: XCTestCase {
    
    var viewModel: RateCollectionViewCellViewModel!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = RateCollectionViewCellViewModel("USDAED", amount: 20000, cCurrency: "USD")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConvertString() {
        let newString = viewModel.convertString(currCurrency: "USD", "USDAEDQWE") // USD -> AEDQWE
        
        XCTAssertEqual(newString, "USD -> AEDQWE", "Convert string to USD -> AEDQWE")
    }
    
}
