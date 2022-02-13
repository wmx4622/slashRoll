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
    private var productQuantityCounter = 1
    private var isEnergyValueShowing = true

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
        productCompositionLabel.numberOfLines = 0
        productCompositionLabel.lineBreakMode = .byWordWrapping
//        productCompositionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return productCompositionLabel
    }()

    private lazy var productCountWeightLabel: SRLabel = {
        let productCountWeightLabel = SRLabel()
        productCountWeightLabel.text = "Количество|вес:"
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
        nameConpostionCountWeightStackView.alignment = .fill
        nameConpostionCountWeightStackView.distribution = .fillProportionally
        return nameConpostionCountWeightStackView
    }()

    private lazy var productFatsLabel: SRLabel = {
        let productFatsLabel = SRLabel()
        productFatsLabel.text = "Жиры"
        return productFatsLabel
    }()

    private lazy var productProteinsLabel: SRLabel = {
        let productProteinsLabel = SRLabel()
        productProteinsLabel.text = "Белки"
        return productProteinsLabel
    }()

    private lazy var productCarbohydratesLabel: SRLabel = {
        let productCarbohydratesLabel = SRLabel()
        productCarbohydratesLabel.text = "Углеводы"
        return productCarbohydratesLabel
    }()

    private var productCaloriesLabel: SRLabel = {
        let productCaloriesLabel = SRLabel()
        productCaloriesLabel.text = "Калорийность"
        return productCaloriesLabel
    }()

    private lazy var productEnergyValueStackView: UIStackView = {
        let productEnergyValueStackView = UIStackView()
        productEnergyValueStackView.axis = .vertical
        productEnergyValueStackView.spacing = 8
        return productEnergyValueStackView
    }()

    private lazy var increaseProductQuantityButton: SRQuantityButton = {
        let increaseProductQuantityButton = SRQuantityButton(title: "+")
        increaseProductQuantityButton.addTarget(self, action: #selector(increaseProductQuantityButtonDidTapped), for: .touchUpInside)
        return increaseProductQuantityButton
    }()

    private lazy var decreaseProductQuantityButton: SRQuantityButton = {
        let increaseProductQuantityButton = SRQuantityButton(title: "-")
        increaseProductQuantityButton.addTarget(self, action: #selector(decreaseProductQuantityButtonDidTapped), for: .touchUpInside)
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

    private lazy var showEnergyValueToggleButton: UIButton = {
        let forgotPasswordButton = UIButton()
        let title = NSMutableAttributedString(string: "Показать энергетическую ценность")
        title.addAttributes([NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.foregroundColor : SRColors.cherryColor], range: NSRange(location: 0, length: title.length))
        forgotPasswordButton.setAttributedTitle(title, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(showEnergyValueToggleDidTapped), for: .touchUpInside)
        return forgotPasswordButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        productImageView.image = UIImage(named: "placeholder")
        view.backgroundColor = SRColors.whiteColor
        setFields(with: shownProduct)
        nameConpostionCountWeightStackView.spacing = 8


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

        productEnergyValueStackView.addArrangedSubview(productProteinsLabel)
        productEnergyValueStackView.addArrangedSubview(productFatsLabel)
        productEnergyValueStackView.addArrangedSubview(productCarbohydratesLabel)
        productEnergyValueStackView.addArrangedSubview(productCaloriesLabel)
        contentView.addSubview(productEnergyValueStackView)
        contentView.addSubview(showEnergyValueToggleButton)


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
            make.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        }

        showEnergyValueToggleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(nameConpostionCountWeightStackView.snp.bottom).offset(8)
        }

        productEnergyValueStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(showEnergyValueToggleButton.snp.bottom).offset(8)

        }

        productPriceStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(productEnergyValueStackView.snp.bottom).offset(8)

        }

        productQuantityStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(productEnergyValueStackView.snp.bottom).offset(8)
        }

        addToCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(productPriceStackView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    private func openCloseEnergyValue() {
        if isEnergyValueShowing {
            contentView.layoutIfNeeded()
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {

                self.productEnergyValueStackView.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }

                self.productCaloriesLabel.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }

                self.productCarbohydratesLabel.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }

                self.productFatsLabel.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }

                self.productProteinsLabel.snp.makeConstraints { make in
                    make.height.equalTo(0)
                }

                self.contentView.layoutIfNeeded()
            }, completion: {_ in
                self.isEnergyValueShowing = false
            })
        } else {

            contentView.layoutIfNeeded()

            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {

                self.productCarbohydratesLabel.snp.remakeConstraints { make in
                    make.height.equalTo(30)
                }

                self.productProteinsLabel.snp.remakeConstraints { make in
                    make.height.equalTo(30)
                }

                self.productFatsLabel.snp.remakeConstraints { make in
                    make.height.equalTo(30)
                }

                self.productCaloriesLabel.snp.remakeConstraints { make in
                    make.height.equalTo(30)
                }

                self.productEnergyValueStackView.snp.remakeConstraints { make in
                    make.top.equalTo(self.showEnergyValueToggleButton.snp.bottom).offset(8)
                    make.height.equalTo(144)
                    make.leading.equalToSuperview().inset(8)
                }

                self.productQuantityStackView.snp.remakeConstraints { make in
                    make.top.equalTo(self.productEnergyValueStackView.snp.bottom).offset(8)
                    make.trailing.equalToSuperview().inset(8)
                }

                self.productPriceStackView.snp.makeConstraints { make in
                    make.top.equalTo(self.productEnergyValueStackView.snp.bottom).offset(8)
                    make.leading.equalToSuperview().inset(8)
                }

                self.productEnergyValueStackView.spacing = 8

                self.contentView.layoutIfNeeded()

            }, completion: {_ in
                self.isEnergyValueShowing.toggle()

            }
            )}
    }
    //MARK: - Controller Configuration

    private func setFields(with product: SRProduct?) {
        guard let product = product else { return }
        productNameLabel.text = product.name
        productCompositionLabel.text = product.composition
        productImageView.image = product.image
        productPriceLabel.text = (String(format: "%.2f", product.price))
        productCountWeightLabel.text = "\(product.count) штук | \(product.weight) грамм"
        productProteinsLabel.text = "\(product.proteins) г/порция"
        productFatsLabel.text = "\(product.fats)  г/порция"
        productCarbohydratesLabel.text = "\(product.carbohydrates) г/порция"
        productCaloriesLabel.text = "\(product.calories) калорий в порции"
    }

    //MARK: - User Interation

    @objc private func increaseProductQuantityButtonDidTapped() {
        if productQuantityCounter < 100 {
            productQuantityCounter += 1
            productQuantityLabel.text = String(productQuantityCounter)
        } else {
            showAlert(title: "Максимальное количество товара", message: "Для оптовой закупки свяжитесь с менджерами")
        }
    }

    @objc private func decreaseProductQuantityButtonDidTapped() {
        if productQuantityCounter > 1 {
            productQuantityCounter -= 1
            productQuantityLabel.text = String(productQuantityCounter)
        }
    }

    @objc private func showEnergyValueToggleDidTapped() {
        print(productEnergyValueStackView.frame.height)
        openCloseEnergyValue()

        }
    }
