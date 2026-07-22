//
//  AxessShopAccessibilityTests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

final class AxessShopAccessibilityTests: AxessShopUITestCase {

    @MainActor
    func testProductListAccessibility() throws {
        let app = launchApp()
        verifyProductListContainsProduct(named: productName, in: app)

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    func testProductDetailAccessibility() throws {
        let app = launchApp()
        navigateToProductDetail(named: productName, in: app)

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    func testEmptyWishlistAccessibility() throws {
        let app = launchApp()
        navigateToWishlist(in: app)

        XCTAssertTrue(
            app.staticTexts["No items in wishlist"].waitForExistence(timeout: existenceTimeout),
            "Expected a newly launched app to have an empty wishlist."
        )

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    func testPopulatedWishlistAccessibility() throws {
        let app = launchApp()
        navigateToProductDetail(named: productName, in: app)
        ensureProductIsInWishlist(named: productName, in: app)
        navigateToWishlist(in: app)
        verifyWishlistContainsProduct(named: productName, in: app)

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    private func performAccessibilityAudit(in app: XCUIApplication) throws {
        // Report every issue found by the audit instead of stopping at the first one.
        continueAfterFailure = true

        try app.performAccessibilityAudit(for: .all) { issue in
            self.isContrastIssueBehindTabBar(issue, in: app)
        }
    }

    @MainActor
    private func isContrastIssueBehindTabBar(
        _ issue: XCUIAccessibilityAuditIssue,
        in app: XCUIApplication
    ) -> Bool {
        // Ignore an iOS 26 Liquid Glass false positive behind the tab bar.
        if #unavailable(iOS 26.0) { return false }

        guard issue.auditType == .contrast,
              let element = issue.element else {
            return false
        }

        // XCUIAudit supplies a lazy SwiftUI proxy. Read its metadata once to
        // materialize the underlying accessibility element before matching it.
        _ = element.elementType
        _ = element.identifier
        _ = element.label

        let identifier = element.identifier
        guard isKnownScrollableContent(identifier),
              element.elementType == .staticText else {
            return false
        }

        let tabBar = app.tabBars.firstMatch
        guard tabBar.exists else { return false }

        // Liquid Glass is rendered beyond the tab bar's accessibility frame.
        let renderedTabBarFrame = tabBar.frame.insetBy(dx: 0, dy: -80)
        return element.frame.intersects(renderedTabBarFrame)
    }

    private func isKnownScrollableContent(_ identifier: String) -> Bool {
        identifier.hasPrefix("product-list-name-")
            || identifier.hasPrefix("product-list-description-")
            || identifier.hasPrefix("product-list-price-")
            || identifier == "product-detail-description"
    }
}
