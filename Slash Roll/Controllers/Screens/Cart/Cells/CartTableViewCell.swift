//
//  CartTableViewCell.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartTableViewCell: UITableViewCell, ReusableCell {

    //MARK:- Properties
    
    private var productQuantityCounter = 1
    private var timer: Timer?
    private let placeholderImage: UIImage = UIImage(named: "placeholder") ?? UIImage()
    private let productImageSize: CGSize = CGSize(width: 60, height: 60)

    //MARK: - GUI varibles
    
    private lazy var productContainerView: UIView = {
        let productContainerView = UIView()
        productContainerView.backgroundColor = SRColors.whiteColor
        return productContainerView
    }()

    private lazy var productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.image = placeholderImage
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = productImageSize.height / 2
        productImageView.layer.borderWidth = 1
        productImageView.layer.borderColor = SRColors.cherryLightColor.cgColor
        return productImageView
    }()


    private lazy var productNameLabel: SRLabel = {
        let productName = SRLabel()
        productName.text = "Name"
        productName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return productName
    }()

    private lazy var countWeightLabel: SRLabel = {
        let countWeightLabel = SRLabel()
        countWeightLabel.text = "Штук|Вес"
        return countWeightLabel
    }()

    private lazy var productPriceLabel: SRLabel = {
        let productPriceLabel = SRLabel()
        productPriceLabel.text = "price"
        return productPriceLabel
    }()

    private lazy var increaseProductQuantityButton: SRQuantityButton = {
        let increaseProductQuantityButton = SRQuantityButton(title: "+")
        increaseProductQuantityButton.addTarget(self, action: #selector(increaseProductQuantityButtonDidTapped), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(increaseProductQuantityButtonLongPress))
        increaseProductQuantityButton.addGestureRecognizer(longPressGesture)
        return increaseProductQuantityButton
    }()

    private lazy var decreaseProductQuantityButton: SRQuantityButton = {
        let decreaseProductQuantityButton = SRQuantityButton(title: "−")
        decreaseProductQuantityButton.addTarget(self, action: #selector(decreaseProductQuantityButtonDidTapped), for: .touchUpInside)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(decreaseProductQuantityButtonLongPress))
        decreaseProductQuantityButton.addGestureRecognizer(longPressGesture)
        return decreaseProductQuantityButton
    }()

    private lazy var productQuantityLabel: SRLabel = {
        let productQuantityLabel = SRLabel()
        productQuantityLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        productQuantityLabel.text = "1"
        return productQuantityLabel
    }()

    private lazy var productQuantityStackView: UIStackView = {
        let productQuantityStackView = UIStackView()
        productQuantityStackView.axis = .vertical
        productQuantityStackView.alignment = .center
        productQuantityStackView.spacing = 8
        return productQuantityStackView
    }()

    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(productContainerView)
        productContainerView.addSubview(productImageView)
        productContainerView.addSubview(productNameLabel)
        productContainerView.addSubview(countWeightLabel)
        productContainerView.addSubview(productPriceLabel)

        productQuantityStackView.addArrangedSubview(increaseProductQuantityButton)
        productQuantityStackView.addArrangedSubview(productQuantityLabel)
        productQuantityStackView.addArrangedSubview(decreaseProductQuantityButton)
        productContainerView.addSubview(productQuantityStackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }

    //MARK: - Cell appearance configuration

    private func configureLayout() {

        productContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalTo(countWeightLabel.snp.centerY)
            make.height.width.equalTo(productImageSize)
        }

        productNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(productImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(productQuantityStackView.snp.leading).inset(-8)
        }

        countWeightLabel.snp.makeConstraints { make in
            make.leading.equalTo(productNameLabel.snp.leading)
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }

        productQuantityStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
        }

        productPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(productNameLabel.snp.leading)
            make.top.equalTo(countWeightLabel.snp.bottom).offset(8)
            make.bottom.equalTo(productQuantityStackView.snp.bottom).inset(8)
        }
    }

    func setCell(cartItem: SRProductInCart) {
        self.productImageView.image = self.placeholderImage
        self.productNameLabel.text = cartItem.product.name
        self.countWeightLabel.text = "\(cartItem.product.count) штук | \(cartItem.product.weight) грамм"
        self.productPriceLabel.text = "Цена \(String(format: "%.2f", cartItem.product.price)) руб."
        self.productQuantityLabel.text = "\(cartItem.quantity)"
    }

    //MARK: - User Interaction

    private func increaseProductQuantity() {
        if productQuantityCounter < 100 {
            productQuantityCounter += 1
            productQuantityLabel.text = String(productQuantityCounter)
        }
    }

    private func decreaseProductQuantity() {
        if productQuantityCounter > 1 {
            productQuantityCounter -= 1
            productQuantityLabel.text = String(productQuantityCounter)
        }
    }

    @objc private func increaseProductQuantityButtonDidTapped() {
        increaseProductQuantity()
    }

    @objc private func decreaseProductQuantityButtonDidTapped() {
        decreaseProductQuantity()
    }

    @objc private func increaseProductQuantityButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(increaseProductQuantityButtonDidTapped), userInfo: nil, repeats: true)
            timer?.tolerance = 0.02
        } else if sender.state == .ended || sender.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc private func decreaseProductQuantityButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(decreaseProductQuantityButtonDidTapped), userInfo: nil, repeats: true)
            timer?.tolerance = 0.02
        } else if sender.state == .ended || sender.state == .cancelled {
            timer?.invalidate()
            timer = nil
        }
    }
}

