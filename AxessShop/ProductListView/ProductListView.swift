//
//  ProductListView.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/12/25.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var store: TechStore

    var body: some View {
        // MARK: Accessible Version Selection
        ProductListViewV3()
    }
}

#Preview {
    ProductListView()
}
