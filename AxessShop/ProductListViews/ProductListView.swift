//
//  ProductListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductListView: View {
    let product: Product

    var body: some View {
        ProductListViewV2(product: product)
    }
}

#Preview {
    ProductListView(product: Product.mockProducts[0])
}
