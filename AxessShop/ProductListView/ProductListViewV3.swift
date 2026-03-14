//
//  ProductListViewV2.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/12/25.
//

import SwiftUI

// Enhanced Accessibility
struct ProductListViewV3: View {
    @EnvironmentObject var store: TechStore

    @Environment(\.accessibilityVoiceOverEnabled) var isVoiceOverEnabled

    var body: some View {
        NavigationStack {
            List(store.products) { product in
                HStack {
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCellViewV3NoButtons(product: product)
                    }
//                    .accessibilityAction(named: !store.existsInWishlist(product) ? "Add to Wishlist" : "Remove from wishlist") {
//                        if store.existsInWishlist(product) {
//                            store.removeFromWishlist(product)
//                        } else {
//                            store.addToWishlist(product)
//                        }
//                    }
//                    .accessibilityAction(named: "Add to Cart") {
//                        store.addToCart(product)
//                    }

                    VStack(spacing: 15) {
                        Button(action: {
                            store.addToCart(product)
                        }) {
                            Image(systemName: "cart.badge.plus")
                                .font(.title2)
                                .accessibilityLabel("Add to Cart")
                        }

                        if !store.existsInWishlist(product) {

                            Button(action: {
                                store.addToWishlist(product)
                            }) {
                                Image(systemName: "heart")
                                    .font(.title2)
                                    .accessibilityLabel("Add to Wishlist")
                            }
                        } else {
                            // Already in wishlist
                            Button(action: {
                                store.removeFromWishlist(product)
                            }) {
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .accessibilityLabel("Remove from Wishlist")
                            }
                        }
                    }

                }
                .accessibilityElement(children: isVoiceOverEnabled ? .combine : .contain)


            }
            .navigationTitle("Tech Store")
        }
    }
}

#Preview {
    ProductListViewV3()
}
