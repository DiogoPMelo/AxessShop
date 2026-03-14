//
//  ProductListViewV2.swift
//  AxessShop
//
//  Created by Diogo Melo on 17/12/25.
//

import SwiftUI

// Accessible implementation
struct ProductListViewV2: View {
    @EnvironmentObject var store: TechStore

    var body: some View {
        NavigationStack {
            List(store.products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCellViewV2(product: product)
                }
            }
            .navigationTitle("Tech Store")
        }
    }
}

#Preview {
    ProductListViewV2()
}
