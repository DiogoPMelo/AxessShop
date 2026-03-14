//
//  ListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

// Base implementation, default accessibility
struct ProductListViewV1: View {
    @EnvironmentObject var store: TechStore

    var body: some View {
        NavigationStack {
            List(store.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCellViewV1(product: product)
                }
            }
            .navigationTitle("Tech Store")
        }
    }
}

#Preview {
    ProductListViewV1()
}
