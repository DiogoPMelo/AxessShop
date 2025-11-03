//
//  WishlistUIKitView.swift
//  AxessShop
//
//  Created by Diogo Melo on 3/11/25.
//

import SwiftUI

struct WishlistView: UIViewControllerRepresentable {
    @ObservedObject var store: TechStore

    func makeUIViewController(context: Context) -> UINavigationController {
        let wishlistVC = WishlistCollectionViewController(store: store)
        let navController = UINavigationController(rootViewController: wishlistVC)
        return navController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // implemented in WishlistVC
    }
}
