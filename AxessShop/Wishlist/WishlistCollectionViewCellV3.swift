//
//  WishlistCollectionViewCellV3.swift
//  AxessShop
//
//  Created by Diogo Melo on 4/11/25.
//

import UIKit

// Accessibility Enhancements
class WishlistCollectionViewCellV3: UICollectionViewCell {

    static let reuseIdentifier = "ProductCell"

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let removeFromWishlistButton = UIButton(type: .system)
    private let addToCartButton = UIButton(type: .system)
    private let infoStackView = UIStackView()
    private let stackView = UIStackView()
    private var product: Product!

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(voiceOverStatusDidChange),
            name: UIAccessibility.voiceOverStatusDidChangeNotification,
            object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.isAccessibilityElement = false
        accessibilityCustomActions = nil

        print(product.name)
    }

    @objc private func voiceOverStatusDidChange() {

        print("mudou voiceover")
        prepareForReuse()
//        setAccessibility()
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

        infoStackView.axis = .vertical
        infoStackView.spacing = 6
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(ratingLabel)

        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 8
        buttonsStackView.addArrangedSubview(removeFromWishlistButton)
        buttonsStackView.addArrangedSubview(addToCartButton)

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(infoStackView)
        stackView.addArrangedSubview(buttonsStackView)
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

            self.product = product
            assert(product != nil, "No product")

            nameLabel.text = product.name
        priceLabel.text = product.price
        ratingLabel.text = String(repeating: "⭐️", count: Int(product.rating))

        setAccessibility()
    }

    func setAccessibility() {

        print("configurando a11y")
        self.infoStackView.isAccessibilityElement = true
        self.infoStackView.accessibilityLabel = "\(product.name), \(product.price), rated \(product.ratingAsString) stars"
        removeFromWishlistButton.accessibilityLabel = "Remove from Wishlist"
        removeFromWishlistButton.accessibilityHint = "Double tap to remove from Wishlist"
        addToCartButton.accessibilityHint = "Double tap to add to Cart"

        if UIAccessibility.isVoiceOverRunning {
configureVoiceOver()
            print("Configurou VO")
        }
    }

    private func configureVoiceOver() {

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
