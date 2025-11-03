//
//  MainTabView.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var store = TechStore()

    var body: some View {
        TabView {

ProductListView()
            .tabItem {
                Label("Store", systemImage: "bag.fill")
            }

            // 2️⃣ Cart
        NavigationStack {
                Text("Cart – To be implemented")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .navigationTitle("Cart")
            }
            .tabItem {
                Label("Cart", systemImage: "cart.fill")
            }
            .badge(store.cartCount)

            // 3️⃣ Favorites
            WishlistView(store: store)
            .tabItem {
                Label("Wishlist", systemImage: "heart.fill")
            }
            .badge(store.wishlistCount)

            // 4️⃣ Account
AccountView()
            .tabItem {
                Label("Account", systemImage: "person.crop.circle.fill")
            }
        }
        .environmentObject(store)
    }
}

#Preview {
    MainTabView()
}
