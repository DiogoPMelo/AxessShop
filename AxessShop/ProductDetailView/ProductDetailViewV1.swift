//
//  ProductDetailViewV1.swift
//  AxessShop
//
//  Created by Diogo Melo on 9/10/25.
//

import SwiftUI

struct ProductDetailViewV1: View {
    let product: Product
    @EnvironmentObject var store: TechStore
    @State private var selectedColor = "blue"
    @State private var selectedStorage = "256GB"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: Product Image
                Image(systemName: product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .foregroundStyle(.gray)
                    .padding(.top)

                // MARK: Title, Rating, Price
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)

                    // Stars
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }

                    Text(product.price)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // MARK: Color Options
                VStack(alignment: .leading, spacing: 10) {
                    Text("Available Colors")
                        .font(.headline)

                    HStack(spacing: 15) {
                        colorButton("black", color: .black)
                        colorButton("blue", color: .blue)
                        colorButton("red", color: .red)
                        colorButton("gray", color: .gray)
                    }
                }
                .padding(.horizontal)

                // MARK: Storage Options
                VStack(alignment: .leading, spacing: 10) {
                    Text("Storage Options")
                        .font(.headline)

                    HStack(spacing: 15) {
                        storageButton("128GB")
                        storageButton("256GB")
                        storageButton("512GB")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)

                // MARK: Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)

                    Text("""
                    The \(product.name) delivers extraordinary performance and unmatched design. \
                    Crafted with precision and innovation, it offers stunning speed, all-day battery life, \
                    and a display that brings everything to life. Perfect for those who demand power, \
                    style, and seamless connectivity — experience the future in your hands.
                    """)
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // MARK: Selected Configuration
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your specs: \(selectedColor.capitalized) / \(selectedStorage)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // MARK: Action Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        store.addToCart(product)
                    }) {
                        Text("Add to Cart")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    if store.existsInWishlist(product) {
                        Button(action: {
                            store.removeFromWishlist(product)
                        }) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding()
                                .frame(width: 56, height: 56)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: {
                            store.addToWishlist(product)
                        }) {
                            Image(systemName: "heart")
                                .font(.title2)
                                .padding()
                                .frame(width: 56, height: 56)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Views

    @ViewBuilder private func colorButton(_ id: String, color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(selectedColor == id ? Color.blue : Color.clear, lineWidth: 3)
            )
            .onTapGesture {
                selectedColor = id
            }
            .accessibilityElement()
    }

    @ViewBuilder private func storageButton(_ label: String) -> some View {
        Button(label) {
            selectedStorage = label
        }
        .padding(10)
        .frame(width: 80)
        .background(selectedStorage == label ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ProductDetailViewV1(product: Product.mockProducts[0])
}
