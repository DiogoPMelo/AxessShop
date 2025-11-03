//
//  WishlistCollectionViewCellV2.swift
//  AxessShop
//
//  Created by Diogo Melo on 3/11/25.
//

import UIKit

class WishlistCollectionViewCellV2: UICollectionViewCell {

    static let reuseIdentifier = "ProductCell"

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let removeFromWishlistButton = UIButton(type: .system)
    private let addToCartButton = UIButton(type: .system)
    private let stackView = UIStackView()

    var onWishlistRemoval: (() -> Void)?
    var onAddToCart: (() -> Void)?
    var onAccessibilityActivate: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        priceLabel.textColor = .systemGreen
        ratingLabel.font = .systemFont(ofSize: 14)

        removeFromWishlistButton.setTitle("♡ Wishlist", for: .normal)
        removeFromWishlistButton.addTarget(self, action: #selector(wishlistTapped), for: .touchUpInside)

        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.tintColor = .white
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.addTarget(self, action: #selector(addCartTapped), for: .touchUpInside)

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(removeFromWishlistButton)
        stackView.addArrangedSubview(addToCartButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = product.price
        ratingLabel.text = String(repeating: "⭐️", count: Int(product.rating))

configureAccessibility(with: product)
    }

        private func configureAccessibility(with product: Product) {

            self.isAccessibilityElement = true
            self.accessibilityLabel = "\(product.name), \(product.price), rated \(product.ratingAsString) stars"
            self.accessibilityHint = "Swipe up or down to select a custom action"
            self.accessibilityTraits = [.button]

        let addToCartAction = UIAccessibilityCustomAction(name: "Add to Cart") { _ in
            self.onAddToCart?()
            return true
        }
        let wishlistAction = UIAccessibilityCustomAction(name: "Remove from Wishlist") { _ in
            self.onWishlistRemoval?()
            return true
        }

            self.accessibilityCustomActions = [addToCartAction, wishlistAction]
                    }

    @objc private func wishlistTapped() {
        onWishlistRemoval?()
    }

    @objc private func addCartTapped() {
        onAddToCart?()
    }

    override func accessibilityActivate() -> Bool {
        self.onAccessibilityActivate?()
        return true
    }
}
