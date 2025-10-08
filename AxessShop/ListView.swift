//
//  ListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

struct ListView: View {
    let products = Product.mockProducts

    var body: some View {
        NavigationStack {
            List(products) { product in
                ListElementView(product: product)
            }
            .navigationTitle("Tech Store")
        }
    }
}

#Preview {
    ListView()
}
