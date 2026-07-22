//
//  AxessShopAccessibilityTests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

final class AxessShopAccessibilityTests: XCTestCase {

    private let productName = "iPhone 15 Pro"
    private let existenceTimeout: TimeInterval = 5

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    @MainActor
    private func navigateToProductDetail(named productName: String, in app: XCUIApplication) {
        let product = verifyProductListContainsProduct(named: productName, in: app)
        product.tap()

        XCTAssertTrue(
            app.navigationBars["Product Details"].waitForExistence(timeout: existenceTimeout),
            "Expected to navigate to the product detail screen."
        )
    }

    @MainActor
    @discardableResult
    private func verifyProductListContainsProduct(
        named productName: String,
        in app: XCUIApplication
    ) -> XCUIElement {
        let product = app.staticTexts[productName].firstMatch
        XCTAssertTrue(
            product.waitForExistence(timeout: existenceTimeout),
            "Expected the mock product \(productName) to appear in the product list."
        )
        return product
    }

    @MainActor
    private func ensureProductIsInWishlist(named productName: String, in app: XCUIApplication) {
        let addToWishlistButton = app.buttons["Add to Wishlist"]
        let removeFromWishlistButton = app.buttons["Remove from Wishlist"]

        if addToWishlistButton.waitForExistence(timeout: existenceTimeout) {
            addToWishlistButton.tap()
        } else {
            XCTAssertTrue(
                removeFromWishlistButton.exists,
                "Expected the product detail screen to expose a wishlist button."
            )
        }

        XCTAssertTrue(
            removeFromWishlistButton.waitForExistence(timeout: existenceTimeout),
            "Expected \(productName) to be added to the wishlist."
        )
    }

    @MainActor
    private func navigateToWishlist(in app: XCUIApplication) {
        let wishlistTab = app.tabBars.buttons["Wishlist"]
        XCTAssertTrue(
            wishlistTab.waitForExistence(timeout: existenceTimeout),
            "Expected the Wishlist tab to appear."
        )
        wishlistTab.tap()

        XCTAssertTrue(
            app.navigationBars["Wishlist"].waitForExistence(timeout: existenceTimeout),
            "Expected to navigate to the Wishlist screen."
        )
    }

    @MainActor
    private func verifyWishlistContainsProduct(named productName: String, in app: XCUIApplication) {
        let wishlistProduct = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", productName))
            .firstMatch

        XCTAssertTrue(
            wishlistProduct.waitForExistence(timeout: existenceTimeout),
            "Expected the wishlist to contain \(productName)."
        )
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
