//
//  ProductDetailViewV1.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductDetailViewV1: View {
    let product: Product
    @EnvironmentObject var store: TechStore

    var body: some View {
        Text(product.name)
    }
}

#Preview {
    ProductDetailViewV1(product: Product.mockProducts[0])
}
