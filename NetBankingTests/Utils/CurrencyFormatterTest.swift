//
//  CurrencyFormatterTest.swift
//  NetBankingTests
//
//  Created by JiTHiN on 16/11/24.
//

import Foundation
import XCTest
@testable import NetBanking

class CurrencyFormatterTest: XCTestCase {
    var formatter: CurrencyFormatter!
    
    override func setUp(){
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsAndCents() throws{
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, " 9,29,466")
        XCTAssertEqual(result.1, "23")
    }
    
    func testDollarsFormat() throws{
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "₹ 9,29,466.23")
    }
    
    func testZeroDollarsFormat() throws{
        let result = formatter.dollarsFormatted(0)
        XCTAssertEqual(result, "₹ 0.00")
    }
}
