//
//  AxessShopAccessibilityTests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

final class AxessShopAccessibilityTests: AxessShopUITestCase {

    @MainActor
    func testProductListAccessibilityInLightMode() throws {
        try auditProductList(appearance: .light)
    }

    @MainActor
    func testProductListAccessibilityInDarkMode() throws {
        try auditProductList(appearance: .dark)
    }

    @MainActor
    func testProductDetailAccessibilityInLightMode() throws {
        try auditProductDetail(appearance: .light)
    }

    @MainActor
    func testProductDetailAccessibilityInDarkMode() throws {
        try auditProductDetail(appearance: .dark)
    }

    @MainActor
    func testEmptyWishlistAccessibilityInLightMode() throws {
        try auditEmptyWishlist(appearance: .light)
    }

    @MainActor
    func testEmptyWishlistAccessibilityInDarkMode() throws {
        try auditEmptyWishlist(appearance: .dark)
    }

    @MainActor
    func testPopulatedWishlistAccessibilityInLightMode() throws {
        try auditPopulatedWishlist(appearance: .light)
    }

    @MainActor
    func testPopulatedWishlistAccessibilityInDarkMode() throws {
        try auditPopulatedWishlist(appearance: .dark)
    }

    @MainActor
    private func auditProductList(appearance: XCUIDevice.Appearance) throws {
        let app = launchApp(appearance: appearance)
        verifyProductListContainsProduct(named: productName, in: app)

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    private func auditProductDetail(appearance: XCUIDevice.Appearance) throws {
        let app = launchApp(appearance: appearance)
        navigateToProductDetail(named: productName, in: app)

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    private func auditEmptyWishlist(appearance: XCUIDevice.Appearance) throws {
        let app = launchApp(appearance: appearance)
        navigateToWishlist(in: app)

        XCTAssertTrue(
            app.staticTexts["No items in wishlist"].waitForExistence(timeout: existenceTimeout),
            "Expected a newly launched app to have an empty wishlist."
        )

        try performAccessibilityAudit(in: app)
    }

    @MainActor
    private func auditPopulatedWishlist(appearance: XCUIDevice.Appearance) throws {
        let app = launchApp(appearance: appearance)
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

        guard issue.auditType == .contrast else {
            return false
        }

        let tabBar = app.tabBars.firstMatch
        guard tabBar.exists else { return false }

        // Liquid Glass is rendered beyond the tab bar's accessibility frame.
        let renderedTabBarFrame = tabBar.frame.insetBy(dx: 0, dy: -80)

        // On iOS 26 XCUIAudit occasionally omits the issue element entirely.
        // In that case, independently verify that identified scroll content is
        // currently rendered behind the tab bar before ignoring the issue.
        guard let element = issue.element else {
            return knownScrollableContentIsBehindTabBar(
                in: app,
                tabBarFrame: renderedTabBarFrame
            )
        }

        // XCUIAudit supplies a lazy SwiftUI proxy. Read its metadata once to
        // materialize the underlying accessibility element before matching it.
        _ = element.elementType
        _ = element.identifier
        _ = element.label

        let identifier = element.identifier
        guard isKnownScrollableContent(identifier) else {
            return false
        }

        return element.frame.intersects(renderedTabBarFrame)
    }

    @MainActor
    private func knownScrollableContentIsBehindTabBar(
        in app: XCUIApplication,
        tabBarFrame: CGRect
    ) -> Bool {
        app.descendants(matching: .any).allElementsBoundByIndex.contains { element in
            isKnownScrollableContent(element.identifier)
                && element.frame.intersects(tabBarFrame)
        }
    }

    private func isKnownScrollableContent(_ identifier: String) -> Bool {
        identifier.hasPrefix("product-list-name-")
            || identifier.hasPrefix("product-list-description-")
            || identifier.hasPrefix("product-list-price-")
            || identifier.hasPrefix("product-list-rating-")
            || identifier == "product-detail-description"
    }
}
