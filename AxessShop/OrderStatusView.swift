//
//  OrderStatusView.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/10/25.
//

import SwiftUI

struct OrderStatusView: View {
    let orderNumber = "O958372"
    let orderDate = "September 28, 2025"

    // Example statuses
    let allStatuses = [
        "Order Placed",
        "Processing",
        "Shipped",
        "Out for Delivery",
        "Delivered"
    ]

    // Example current status index
    @State private var currentStatus = 3 // Out for Delivery

    // Example ordered products
    let products = [
        Product.mockProducts[0],
        Product.mockProducts[1],
    Product.mockProducts[2]
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Order \(orderNumber)")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Placed on \(orderDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)

                // MARK: - Order Status
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(Array(allStatuses.enumerated()), id: \.offset) { index, status in
                            statusView(for: status, index: index, currentIndex: currentStatus)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }

                Divider()
                    .padding(.horizontal)

                // MARK: - Ordered Items
                VStack(alignment: .leading, spacing: 16) {
                    Text("Items in this Order")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(products, id: \.name) { product in
                        HStack(spacing: 16) {
                            Image(systemName: product.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(product.name)
                                    .font(.headline)

                                Text(product.price)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Status View Builder

    @ViewBuilder
    private func statusView(for status: String, index: Int, currentIndex: Int) -> some View {
        if index < currentIndex {
            // PAST STATUS
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.green.opacity(0.8))
                    .frame(width: 20, height: 20)
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.green.opacity(0.8))
            }
            .accessibilityHint("Past")

        } else if index == currentIndex {
            // CURRENT STATUS
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                Text(status)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .accessibilityHint("Current")

        } else {
            // FUTURE STATUS
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 20, height: 20)
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .accessibilityHint("Future")
        }
    }

}

#Preview {
    NavigationStack {
        OrderStatusView()
    }
}
