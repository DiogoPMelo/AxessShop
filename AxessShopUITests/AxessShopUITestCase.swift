//
//  AxessShopUITestCase.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

class AxessShopUITestCase: XCTestCase {

    let productName = "iPhone 15 Pro"
    let existenceTimeout: TimeInterval = 5
    private var originalAppearance: XCUIDevice.Appearance = .unspecified

    override func setUpWithError() throws {
        originalAppearance = XCUIDevice.shared.appearance
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        XCUIDevice.shared.appearance = originalAppearance
    }

    @MainActor
    func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    @MainActor
    func launchApp(appearance: XCUIDevice.Appearance) -> XCUIApplication {
        XCUIDevice.shared.appearance = appearance
        return launchApp()
    }

    @MainActor
    func navigateToProductDetail(named productName: String, in app: XCUIApplication) {
        let product = verifyProductListContainsProduct(named: productName, in: app)
        product.tap()

        XCTAssertTrue(
            app.navigationBars["Product Details"].waitForExistence(timeout: existenceTimeout),
            "Expected to navigate to the product detail screen."
        )
    }

    @MainActor
    @discardableResult
    func verifyProductListContainsProduct(
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
    func ensureProductIsInWishlist(named productName: String, in app: XCUIApplication) {
        let wishlistButton = app.buttons["product-detail-wishlist-button"]
        XCTAssertTrue(
            wishlistButton.waitForExistence(timeout: existenceTimeout),
            "Expected the product detail screen to expose a wishlist button."
        )

        if !wishlistButton.isSelected {
            wishlistButton.tap()
        }

        // SwiftUI can replace the underlying node after the state change.
        let updatedWishlistButton = app.buttons["product-detail-wishlist-button"]
        XCTAssertTrue(
            updatedWishlistButton.waitForExistence(timeout: existenceTimeout)
                && updatedWishlistButton.isSelected,
            "Expected \(productName) to be added to the wishlist."
        )
    }

    @MainActor
    func navigateToWishlist(in app: XCUIApplication) {
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
    func verifyWishlistContainsProduct(named productName: String, in app: XCUIApplication) {
        let wishlistProduct = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", productName))
            .firstMatch

        XCTAssertTrue(
            wishlistProduct.waitForExistence(timeout: existenceTimeout),
            "Expected the wishlist to contain \(productName)."
        )
    }
}
