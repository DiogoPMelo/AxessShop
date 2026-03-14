//
//  ProductCellViewV3.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/12/25.
//

import SwiftUI

// Implementation with no Buttons, implemented in ProductListViewV3 for Accessibility Enhancements
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

        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
            }
}

#Preview {
    ProductCellViewV3NoButtons(product: Product.mockProducts[0])
}
