//
//  WishlistCell.swift
//  AxessShop
//
//  Created by Diogo Melo on 3/11/25.
//

import UIKit

final class WishlistTableCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    let addToCartButton = UIButton(type: .system)

    private var product: Product?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, ratingLabel])
        stack.axis = .vertical
        stack.spacing = 4

        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        let mainStack = UIStackView(arrangedSubviews: [stack, addToCartButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center

        contentView.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])

        self.isAccessibilityElement = true
            }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = product.price
        ratingLabel.text = "⭐️ \(product.ratingAsString)"

        self.accessibilityLabel = "\(product.name), \(product.price), rated \(product.ratingAsString) stars"
    }
}
