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

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
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
