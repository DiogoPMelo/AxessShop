//
//  ProductDetailView.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    var body: some View {
        ProductDetailViewV1(product: product)
    }
}

#Preview {
    ProductDetailView(product: Product.mockProducts[0])
}
