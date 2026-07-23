//
//  AxessShopProductListUITests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 23/7/26.
//

import XCTest

final class AxessShopProductListUITests: AxessShopUITestCase {

    @MainActor
    func testProductListExposesCartAndWishlistButtons() {
        let app = launchApp()
        verifyProductListContainsProduct(named: productName, in: app)

        let addToCartButton = app.buttons
            .matching(identifierBeginningWith: "product-list-add-to-cart-")
            .firstMatch
        assertButton(
            addToCartButton,
            hasLabel: "Add to Cart",
            message: "Expected the product list to expose an Add to Cart button."
        )

        let wishlistButton = app.buttons
            .matching(identifierBeginningWith: "product-list-wishlist-")
            .firstMatch
        assertButton(
            wishlistButton,
            hasLabel: "Add to Wishlist",
            message: "Expected the product list to expose an Add to Wishlist button."
        )
    }

    @MainActor
    private func assertButton(
        _ button: XCUIElement,
        hasLabel expectedLabel: String,
        message: String
    ) {
        XCTAssertTrue(
            button.waitForExistence(timeout: existenceTimeout),
            message
        )
        XCTAssertEqual(button.elementType, .button)
        XCTAssertEqual(button.label, expectedLabel)
    }
}

private extension XCUIElementQuery {
    func matching(identifierBeginningWith prefix: String) -> XCUIElementQuery {
        matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix))
    }
}
