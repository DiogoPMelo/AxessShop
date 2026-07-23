//
//  ProductCellViewV3.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/12/25.
//

import SwiftUI

// Implementation with no Buttons, implemented in ProductListViewV3 for Enhanced Accessibility
struct ProductCellViewV3NoButtons: View {
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
                    .accessibilityIdentifier("product-list-name-\(product.id)")

                Text(product.description)
                    .font(.subheadline)
                    .accessibilityIdentifier("product-list-description-\(product.id)")

                Text(product.price)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .accessibilityIdentifier("product-list-price-\(product.id)")

                HStack {
                    ForEach(0..<Int(product.rating.rounded())) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rating: \(product.ratingAsString) stars")
                .accessibilityIdentifier("product-list-rating-\(product.id)")
            }
            Spacer()

        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
            }
}

#Preview {
    ProductCellViewV3NoButtons(product: Product.mockProducts[0])
}
