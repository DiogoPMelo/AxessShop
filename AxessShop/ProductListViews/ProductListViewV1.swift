//
//  ProductListViewV1.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

// First implementation, no accessibility care
struct ProductListViewV1: View {
    let product: Product
    @EnvironmentObject var store: TechStore

    var body: some View {
        HStack {
            Image(systemName: product.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)

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
            }
            Spacer()

            VStack(spacing: 15) {
                Button(action: {
                    store.addToCart(product)
                }) {
                    Image(systemName: "cart.badge.plus")
                        .font(.title2)
                }

                if !store.existsInWishlist(product) {

                    Button(action: {
                        store.addToWishlist(product)
                    }) {
                        Image(systemName: "heart")
                            .font(.title2)
                    }
                } else {
                    // Already in wishlist
                    Button(action: {
                        store.removeFromWishlist(product)
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProductListViewV1(product: Product.mockProducts[0])
}
