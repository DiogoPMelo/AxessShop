//
//  WishlistViewController.swift
//  AxessShop
//
//  Created by Diogo Melo on 3/11/25.
//

import UIKit
import SwiftUI
import Combine

class WishlistViewController: UITableViewController {
    private var store: TechStore
    private var cancellables = Set<AnyCancellable>()

    init(store: TechStore) {

        self.store = store
        super.init(style: .plain)
        self.title = "Wishlist"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(WishlistTableCell.self, forCellReuseIdentifier: "Cell")

        // Observe the wishlist publisher
        store.$wishlist
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.wishlistCount
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WishlistTableCell
        let product = store.wishlist[indexPath.row]
        cell.configure(with: product)

        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCartTapped(_:)), for: .touchUpInside)

        let addToCartAction = UIAccessibilityCustomAction(name: "Add to Cart") { _ in
            self.addToCart(product)
            return true
        }
        cell.accessibilityCustomActions = [addToCartAction]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = store.wishlist[indexPath.row]

        navigateToSwiftUIDetail(for: product)
    }

    // MARK: - Actions
    private func navigateToSwiftUIDetail(for product: Product) {

        let detailView = ProductDetailView(product: product)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    @objc private func addToCartTapped(_ sender: UIButton) {

        let index = sender.tag
        let product = store.wishlist[index]

        addToCart(product)
    }

    func addToCart(_ product: Product) {

        store.cart.append(product)

        if UIAccessibility.isVoiceOverRunning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "\(product.name) added to cart."
                )
            }
        }
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Remove from Wishlist") { [weak self] _, _, completion in
            self?.store.wishlist.remove(at: indexPath.row)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
