//
//  DecemialUtil.swift
//  NetBanking
//
//  Created by JiTHiN on 15/11/24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
