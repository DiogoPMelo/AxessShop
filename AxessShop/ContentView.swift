//
//  ContentView.swift
//  AxessShop
//
//  Created by Diogo Melo on 8/10/25.
//

import SwiftUI

struct Article: Codable, Hashable, Identifiable {
    var id = UUID()
var name: String
var price: Double



}




struct ContentView: View {
    var articles = [
        Article(name: "Socks", price: 9.99),
        Article(name: "shoes", price: 49.99),
        Article(name: "Jeans", price: 99.99),
    ]

    var body: some View {
        List (articles, id: \.self) { item in
            VStack {
                Text(item.name)
                Text("\(item.price)")
                Button ("Buy") {

                }
            }
        }
    }

}

#Preview {
    ContentView()
}
