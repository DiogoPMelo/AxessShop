//
//  AxessShopWishlistUITests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

final class AxessShopWishlistUITests: AxessShopUITestCase {

    @MainActor
    func testRemovingOnlyProductFromWishlistShowsEmptyState() {
        let app = launchApp()
        verifyProductListContainsProduct(named: productName, in: app)

        // The first wishlist button belongs to the first hardcoded mock product.
        let addToWishlistButton = app.buttons["Add to Wishlist"].firstMatch
        XCTAssertTrue(
            addToWishlistButton.waitForExistence(timeout: existenceTimeout),
            "Expected the product list to expose an Add to Wishlist button."
        )
        addToWishlistButton.tap()

        XCTAssertTrue(
            app.buttons["Remove from Wishlist"].firstMatch
                .waitForExistence(timeout: existenceTimeout),
            "Expected \(productName) to be added to the wishlist."
        )

        navigateToWishlist(in: app)
        verifyWishlistContainsProduct(named: productName, in: app)

        let wishlist = app.collectionViews.firstMatch
        XCTAssertTrue(
            wishlist.waitForExistence(timeout: existenceTimeout),
            "Expected the Wishlist screen to contain a collection view."
        )

        let removeFromWishlistButton = wishlist.buttons["Remove from Wishlist"].firstMatch
        XCTAssertTrue(
            removeFromWishlistButton.waitForExistence(timeout: existenceTimeout),
            "Expected the wishlist item to expose a remove button."
        )
        removeFromWishlistButton.tap()

        XCTAssertTrue(
            app.staticTexts["No items in wishlist"]
                .waitForExistence(timeout: existenceTimeout),
            "Expected the Wishlist screen to show its empty state after removal."
        )
    }
}
