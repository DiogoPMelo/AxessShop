//
//  WishListCOllectionViewController.swift
//  AxessShop
//
//  Created by Diogo Melo on 3/11/25.
//

import UIKit
import SwiftUI
import Combine

// MARK: Accessible Version Selection
typealias CellView = WishlistCollectionViewCellV3
class WishlistCollectionViewController: UICollectionViewController {

    private let store: TechStore
    private var cancellables = Set<AnyCancellable>()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No items in your wishlist"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.accessibilityLabel = "No items in wishlist"
        return label
    }()

    init(store: TechStore) {
        self.store = store

        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let width = (UIScreen.main.bounds.width - 3 * padding) / 2
        layout.itemSize = CGSize(width: width, height: 200)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CellView.self, forCellWithReuseIdentifier: CellView.reuseIdentifier)
        self.title = "Wishlist"

        store.$wishlist
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        updateEmptyState()
    }

    private func updateEmptyState() {
        if store.wishlist.isEmpty {
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }

    // MARK: - UICollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
updateEmptyState()
        return store.wishlistCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.reuseIdentifier, for: indexPath) as? CellView else {
            fatalError()
        }

        let product = store.wishlist[indexPath.item]
        cell.configure(with: product)

        // Closures to update ObservableObject
        cell.onWishlistRemoval = { [weak self] in
            self?.removeFromWishlist(product)
        }

        cell.onAddToCart = { [weak self] in
            self?.addToCart(product)
        }

        cell.onAccessibilityActivate = { [weak self] in
            self?.navigateToSwiftUIDetail(for: product)
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = store.wishlist[indexPath.item]

        navigateToSwiftUIDetail(for: product)
            }

    // MARK: Actions
    private func navigateToSwiftUIDetail(for product: Product) {

        let detailView = ProductDetailView(product: product)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

        func addToCart(_ product: Product) {

        store.cart.append(product)

makeVoiceOverAnnouncement("\(product.name) added to cart.")
    }

    func removeFromWishlist (_ product: Product) {

        store.removeFromWishlist(product)
        self.collectionView.reloadData()

        makeVoiceOverAnnouncement("\(product.name) removed from Wishlist.")
    }


    private func makeVoiceOverAnnouncement(_ message: String) {

        if UIAccessibility.isVoiceOverRunning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: message
                )
            }
        }
    }
}
