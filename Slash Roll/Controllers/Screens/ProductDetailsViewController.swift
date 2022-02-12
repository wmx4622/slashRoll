//
//  ProductDetailsViewController.swift
//  Slash Roll
//
//  Created by Voxar on 10.02.22.
//

import UIKit

class ProductDetaisViewController: SRScrollableViewController {

    //MARK: - Properties

    var shownProduct: SRProduct?

    //MARK: - GUI Varibles

    private lazy var productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 5
        productImageView.layer.borderColor = SRColors.cherryLightColor.cgColor
        productImageView.layer.borderWidth = 1
        return productImageView
    }()

    private lazy var productNameLabel: SRLabel = {
        let productNameLabel = SRLabel()
        productNameLabel.text = "Имя продукта"
        productNameLabel.textColor = SRColors.cherryColor
        productNameLabel.font = .boldSystemFont(ofSize: 20)
        return productNameLabel
    }()

    private lazy var productCompositionLabel: SRLabel = {
        let productCompositionLabel = SRLabel()
        productCompositionLabel.text = "Состав продукта:"
        return productCompositionLabel
    }()

    private lazy var productCountWeightLabel: SRLabel = {
        let productCountWeightLabel = SRLabel()
        productCountWeightLabel.text = "Количество/вес:"
        return productCountWeightLabel
    }()

    private lazy var productPriceLabel: SRLabel = {
        let productPriceLabel = SRLabel()
        productPriceLabel.textColor = SRColors.cherryColor
        productPriceLabel.text = "0"
        productPriceLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        return productPriceLabel
    }()

    private lazy var productPriceСurrencyLabel: SRLabel = {
        let productPriceCurrencyLabel = SRLabel()
        productPriceCurrencyLabel.textColor = SRColors.cherryLightColor
        productPriceCurrencyLabel.text = "руб"
        return productPriceCurrencyLabel
    }()

    private lazy var productPriceStackView: UIStackView = {
        let productPriceStackView = UIStackView()
        productPriceStackView.axis = .horizontal
        productPriceStackView.spacing = 8
        return productPriceStackView
    }()

    private lazy var nameConpostionCountWeightStackView: UIStackView = {
        let nameConpostionCountWeightStackView = UIStackView()
        nameConpostionCountWeightStackView.axis = .vertical
        nameConpostionCountWeightStackView.spacing = 8

        return nameConpostionCountWeightStackView
    }()

    private lazy var increaseProductQuantityButton: SRQuantityButton = {
        let increaseProductQuantityButton = SRQuantityButton(title: "+")
        return increaseProductQuantityButton
    }()

    private lazy var decreaseProductQuantityButton: SRQuantityButton = {
        let increaseProductQuantityButton = SRQuantityButton(title: "-")
        return increaseProductQuantityButton
    }()

    private lazy var productQuantityLabel: SRLabel = {
        let productQuantityLabel = SRLabel()
        productQuantityLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        productQuantityLabel.text = "1"
        return productQuantityLabel
    }()
//
    private lazy var productQuantityStackView: UIStackView = {
        let productQuantityStackView = UIStackView()
        productQuantityStackView.axis = .horizontal
        productQuantityStackView.spacing = 8
        return productQuantityStackView
    }()

    private lazy var addToCartButton: SRButton = {
        let addToCartButton = SRButton()
        addToCartButton.configuration?.title = "Добавить в корзину"
        return addToCartButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        productImageView.image = UIImage(named: "placeholder")
        view.backgroundColor = SRColors.whiteColor
        setFields(with: shownProduct)
    }

    private func addSubviews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(addToCartButton)

        nameConpostionCountWeightStackView.addArrangedSubview(productNameLabel)
        nameConpostionCountWeightStackView.addArrangedSubview(productCountWeightLabel)
        nameConpostionCountWeightStackView.addArrangedSubview(productCompositionLabel)
        contentView.addSubview(nameConpostionCountWeightStackView)

        productPriceStackView.addArrangedSubview(productPriceLabel)
        productPriceStackView.addArrangedSubview(productPriceСurrencyLabel)
        contentView.addSubview(productPriceStackView)

        productQuantityStackView.addArrangedSubview(increaseProductQuantityButton)
        productQuantityStackView.addArrangedSubview(productQuantityLabel)
        productQuantityStackView.addArrangedSubview(decreaseProductQuantityButton)
        contentView.addSubview(productQuantityStackView)

    }

    //MARK: - Layout Configuration

    private func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(200)
        }

        nameConpostionCountWeightStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(productImageView.snp.bottom).offset(8)
        }

        productPriceStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(nameConpostionCountWeightStackView.snp.bottom).offset(8)

        }

        productQuantityStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(nameConpostionCountWeightStackView.snp.bottom).offset(8)
        }

        addToCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(productPriceStackView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    //MARK: - Controller Configuration

    private func setFields(with product: SRProduct?) {
        guard let product = product else { return }
        productNameLabel.text = product.name
        productCompositionLabel.text = product.composition
        productImageView.image = product.image
        productPriceLabel.text = (String(format: "%.2f", product.price))
        productCountWeightLabel.text = "\(product.count) штук | \(product.weight) грамм"
    }
}
