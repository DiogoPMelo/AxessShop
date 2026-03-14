# AxessShop

This is a mock e-commerce app used for a webinar and three Axess Lab articles on iOS accessibility. It covers the evolution of an app, from a default implementation to making it accessible to:

- Full Keyboard Access
- Voice Control
- VoiceOver
- With specific VoiceOver enhancements without breaking the others

## App Structure

The app **evolved through three versions** of key UI components:

### Versions

- **V1 (Base)** – Original implementation, no accessibility focus.
- **V2 (Accessible)** – Added support for **VoiceOver, Voice Control, and Full Keyboard Access**.
- **V3 (Enhanced Accessibility)** – VoiceOver-specific enhancements **without breaking *Voice Control* or Full Keyboard Access**.

The versions can be switched before running the app, by searching for the `// MARK: Accessible Version Selection`.

### Key Components

#### Product Cells
- **ProductCellViewV1 / V2 / V3** – evolving cell implementations
- Used in **ProductListViewV1 / V2 / V3**

#### Product List
- **ProductListView** – defines which ProductListView version to use

#### Product Detail
- **ProductDetailViewV1 / V2 / V3** – evolving detail screens
- **ProductDetailView** – defines which ProductDetailView version to use

#### Wishlist
- **WishlistCollectionViewCellV1 / V2 / V3** – evolving Wishlist cell implementations in UIKit
- **WishlistCollectionViewController** – uses a `typealias` to select the cell version

## Related Articles & Webinar

- **Webinar:** [Developing and testing iOS Apps using a screen reader](https://www.youtube.com/watch?v=sbV3qLJxfv4)

- **Articles:**
  - [Making an iOS e-commerce Product Detail Page accessible to VoiceOver and beyond](https://axesslab.com/making-an-ios-e-commerce-product-detail-page-accessible-to-voiceover-and-beyond/)
  - [Making an iOS e-commerce Product List accessible to VoiceOver and beyond](https://axesslab.com/making-an-ios-e-commerce-product-list-accessible-to-voiceover-and-beyond/)
  - [Optimizing VoiceOver in an iOS e-commerce app with conditional accessibility](https://axesslab.com/optimizing-voiceover-in-an-ios-e-commerce-app-with-conditional-accessibility/)