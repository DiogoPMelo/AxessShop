//
//  Product.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import Foundation
import Combine

class TechStore: ObservableObject {

    var products: [Product]
@Published var wishlist: [Product]
    @Published var cart: [Product]

    init () {

        products = Product.mockProducts
        wishlist = [Product]()
        cart = [Product]()
    }

    var wishlistCount: Int {

        wishlist.count
    }

    var cartCount: Int {

        cart.count
    }

    func addToCart(_ product: Product) {

        cart.append(product)
    }

    func existsInWishlist(_ product: Product) -> Bool {

        wishlist.contains { $0.id == product.id}
    }

    func addToWishlist(_ product: Product) {
        
        if !existsInWishlist(product) {
            wishlist.append(product)
        }
    }

    func removeFromWishlist(_ product: Product) {

        if let index = wishlist.firstIndex { $0.id == product.id } {

            wishlist.remove(at: index)
        }
    }
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    let rating: Double
    let imageName: String
}


extension Product {

    static let mockProducts = [
        Product(name: "iPhone 15 Pro", description: "Titanium design, 256GB", price: "€1299", rating: 4.8, imageName: "iphone.gen3"),
        Product(name: "MacBook Air M3", description: "13-inch, 512GB SSD", price: "€1599", rating: 4.6, imageName: "laptopcomputer"),
        Product(name: "AirPods Pro 2", description: "Active noise cancelling", price: "€279", rating: 4.4, imageName: "earbuds.case"),
        Product(name: "Apple Watch Series 10", description: "Always-On display, GPS", price: "€469", rating: 4.5, imageName: "applewatch"),
        Product(name: "iPad Pro M4", description: "12.9-inch Liquid Retina XDR", price: "€1399", rating: 4.7, imageName: "ipad"),
        Product(name: "HomePod Mini", description: "Smart speaker with Siri", price: "€109", rating: 4.3, imageName: "hifispeaker.fill"),
        Product(name: "Magic Keyboard", description: "Wireless keyboard with Touch ID", price: "€179", rating: 4.2, imageName: "keyboard"),
        Product(name: "Magic Mouse", description: "Rechargeable multi-touch mouse", price: "€99", rating: 3.9, imageName: "computermouse"),
        Product(name: "AirTag 4-Pack", description: "Track your items easily", price: "€119", rating: 4.6, imageName: "dot.radiowaves.up.forward"),
        Product(name: "Apple TV 4K", description: "A15 Bionic, HDR10+", price: "€169", rating: 4.5, imageName: "appletv"),
        Product(name: "Beats Studio Pro", description: "Wireless over-ear headphones", price: "€399", rating: 4.4, imageName: "headphones"),
        Product(name: "iPhone 15", description: "Dynamic Island, 128GB", price: "€999", rating: 4.3, imageName: "iphone.gen2"),
        Product(name: "Mac mini M2", description: "Compact desktop, 512GB SSD", price: "€929", rating: 4.5, imageName: "macmini.fill"),
        Product(name: "Mac Studio M3 Max", description: "Workstation-grade performance", price: "€2499", rating: 4.8, imageName: "server.rack"),
        Product(name: "Studio Display", description: "5K Retina, 27-inch", price: "€1799", rating: 4.4, imageName: "display"),
        Product(name: "Pro Display XDR", description: "6K Retina HDR display", price: "€5599", rating: 4.7, imageName: "display.2"),
        Product(name: "Magic Trackpad", description: "Wireless, Force Touch", price: "€149", rating: 4.3, imageName: "rectangle.and.hand.point.up.left.filled"),
        Product(name: "iPhone Case", description: "Leather MagSafe case", price: "€69", rating: 4.2, imageName: "case.fill"),
        Product(name: "USB-C to Lightning Cable", description: "1 meter charging cable", price: "€25", rating: 4.1, imageName: "cable.connector"),
        Product(name: "AppleCare+ for iPhone", description: "2 years coverage", price: "€199", rating: 4.9, imageName: "shield.checkered")
    ]

}
