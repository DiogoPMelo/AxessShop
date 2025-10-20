//
//  AccountView.swift
//  AxessShop
//
//  Created by Diogo Melo on 16/10/25.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Profile Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diogo Melo")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("diogo@axesslab.com")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Axess Lab")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                } header: {
                    Text("Profile")
                }

                // MARK: - Orders Section
                Section {
                    ForEach(1..<4) { number in
                        NavigationLink(destination: OrderStatusView()) {
                            VStack(alignment: .leading) {
                                Text("Order #\(1000 + number)")
                                    .font(.body)
                                Text("Placed on Sep \(15 + number), 2025")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("My Orders")
                }

                // MARK: - App Info / Credits Section
                Section {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Tech Store")
                            .font(.headline)
                        Text("Version 1.0 • Made with SwiftUI")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
}
