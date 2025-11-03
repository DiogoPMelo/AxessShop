//
//  ProductListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product

    var body: some View {
        ProductCellViewV2(product: product)
    }
}

#Preview {
    ProductCellView(product: Product.mockProducts[0])
}
