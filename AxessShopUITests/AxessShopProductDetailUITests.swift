//
//  AxessShopProductDetailUITests.swift
//  AxessShopUITests
//
//  Created by Diogo Melo on 22/7/26.
//

import XCTest

final class AxessShopProductDetailUITests: AxessShopUITestCase {

    @MainActor
    func testSelectingStorageAndColorUpdatesConfigurationSummary() {
        let app = launchApp()
        navigateToProductDetail(named: productName, in: app)
        let productDetail = productDetailScrollView(in: app)

        let oneTerabyteButton = productDetail.buttons["product-detail-storage-1tb"]
        XCTAssertEqual(oneTerabyteButton.label, "1TB")
        scrollUntilHittable(oneTerabyteButton, in: productDetail, direction: .up)
        oneTerabyteButton.tap()

        XCTAssertEqual(oneTerabyteButton.elementType, .button)
        XCTAssertTrue(oneTerabyteButton.isSelected)
        XCTAssertFalse(productDetail.buttons["product-detail-storage-256gb"].isSelected)

        XCTAssertTrue(
            productDetail.staticTexts["Your specs: Blue / 1TB"]
                .waitForExistence(timeout: existenceTimeout),
            "Expected the selected configuration to update to 1TB."
        )

        let redButton = productDetail.buttons["product-detail-color-red"]
        XCTAssertEqual(redButton.label, "Red")
        scrollUntilHittable(redButton, in: productDetail, direction: .down)
        redButton.tap()

        XCTAssertEqual(redButton.elementType, .button)
        XCTAssertTrue(redButton.isSelected)
        XCTAssertFalse(productDetail.buttons["product-detail-color-blue"].isSelected)

        XCTAssertTrue(
            productDetail.staticTexts["Your specs: Red / 1TB"]
                .waitForExistence(timeout: existenceTimeout),
            "Expected the selected configuration to update to Red and 1TB."
        )
    }

    @MainActor
    func testAddingProductToWishlistUpdatesButton() {
        let app = launchApp()
        navigateToProductDetail(named: productName, in: app)
        let productDetail = productDetailScrollView(in: app)

        let wishlistButton = productDetail.buttons["product-detail-wishlist-button"]

        // Tapping a V3 list row can also trigger its wishlist button, so begin
        // this behavior check from a known, not-in-wishlist state.
        if wishlistButton.label == "Remove from Wishlist" {
            scrollUntilHittable(wishlistButton, in: productDetail, direction: .up)
            wishlistButton.tap()

            XCTAssertEqual(
                wishlistButton.label,
                "Add to Wishlist",
                "Expected to reset \(productName) to the not-in-wishlist state."
            )
        }

        XCTAssertEqual(wishlistButton.elementType, .button)
        XCTAssertEqual(wishlistButton.label, "Add to Wishlist")
        scrollUntilHittable(wishlistButton, in: productDetail, direction: .up)
        wishlistButton.tap()

        XCTAssertEqual(
            wishlistButton.label,
            "Remove from Wishlist",
            "Expected the wishlist button label to change after adding \(productName)."
        )
        XCTAssertTrue(wishlistButton.isSelected)
    }

    @MainActor
    private func productDetailScrollView(in app: XCUIApplication) -> XCUIElement {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(
            scrollView.waitForExistence(timeout: existenceTimeout),
            "Expected the product detail screen to contain a scroll view."
        )
        return scrollView
    }

    private enum ScrollDirection {
        case up
        case down
    }

    @MainActor
    private func scrollUntilHittable(
        _ element: XCUIElement,
        in scrollView: XCUIElement,
        direction: ScrollDirection
    ) {
        let maximumSwipeCount = 6
        var swipeCount = 0

        while !element.isHittable && swipeCount < maximumSwipeCount {
            switch direction {
            case .up:
                scrollView.swipeUp()
            case .down:
                scrollView.swipeDown()
            }
            swipeCount += 1
        }

        XCTAssertTrue(
            element.isHittable,
            "Expected \(element) to become hittable after scrolling."
        )
    }
}
