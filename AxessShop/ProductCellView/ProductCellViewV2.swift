//
//  ProductListViewV2.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductCellViewV2: View {
    let product: Product
    @EnvironmentObject var store: TechStore

    var body: some View {
        HStack {
            Image(systemName: product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 15) {
                Text(product.name)
                    .font(.headline)

                Text(product.description)
                    .font(.subheadline)

                Text(product.price)
                    .font(.title3)
                    .foregroundColor(.green)

                HStack {
                    ForEach(0..<Int(product.rating.rounded())) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rating: \(product.ratingAsString) stars")
            }
            Spacer()

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
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: !store.existsInWishlist(product) ? "Add to Wishlist" : "Remove from wishlist") {
            if store.existsInWishlist(product) {
                store.removeFromWishlist(product)
            } else {
                store.addToWishlist(product)
            }
        }
        .accessibilityAction(named: "Add to Cart") {
            store.addToCart(product)
        }
//        .accessibilityAction(.magicTap, {store.addToWishlist(product)})
//        .accessibilityAction(.escape, {store.removeFromWishlist(product)})
    }
}

#Preview {
    ProductCellViewV2(product: Product.mockProducts[0])
}
