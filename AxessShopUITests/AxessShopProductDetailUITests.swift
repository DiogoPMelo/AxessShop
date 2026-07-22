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

        let oneTerabyteButton = productDetail.buttons["1TB"]
        scrollUntilHittable(oneTerabyteButton, in: productDetail, direction: .up)
        oneTerabyteButton.tap()

        XCTAssertTrue(
            productDetail.staticTexts["Your specs: Blue / 1TB"]
                .waitForExistence(timeout: existenceTimeout),
            "Expected the selected configuration to update to 1TB."
        )

        let redButton = productDetail.buttons["Red"]
        scrollUntilHittable(redButton, in: productDetail, direction: .down)
        redButton.tap()

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

        let addToWishlistButton = productDetail.buttons["Add to Wishlist"]
        let removeFromWishlistButton = productDetail.buttons["Remove from Wishlist"]

        // Tapping a V3 list row can also trigger its wishlist button, so begin
        // this behavior check from a known, not-in-wishlist state.
        if removeFromWishlistButton.exists {
            scrollUntilHittable(removeFromWishlistButton, in: productDetail, direction: .up)
            removeFromWishlistButton.tap()

            XCTAssertTrue(
                addToWishlistButton.waitForExistence(timeout: existenceTimeout),
                "Expected to reset \(productName) to the not-in-wishlist state."
            )
        }

        scrollUntilHittable(addToWishlistButton, in: productDetail, direction: .up)
        addToWishlistButton.tap()

        XCTAssertTrue(
            removeFromWishlistButton.waitForExistence(timeout: existenceTimeout),
            "Expected the wishlist button to change after adding \(productName)."
        )
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
