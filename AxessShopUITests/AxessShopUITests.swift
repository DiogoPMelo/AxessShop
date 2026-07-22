//
//  AxessShopUITests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 8/10/25.
//

import XCTest

final class AxessShopUITests: XCTestCase {

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
