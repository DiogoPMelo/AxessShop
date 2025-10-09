//
//  ListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var store: TechStore

    var body: some View {
        NavigationStack {
            List(store.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductListView(product: product)
                }
            }
            .navigationTitle("Tech Store")
        }
    }
}

#Preview {
    ListView()
}
