//
//  ProductDetailsViewController.swift
//  Slash Roll
//
//  Created by Voxar on 10.02.22.
//

import UIKit
import SnapKit


class ProductDetaisViewController: SRScrollableViewController {

    //MARK: - Properties

    var shownProduct: SRProduct?
    private var timer: Timer?
    private lazy var productQuantityCounter = 1
    private lazy var isEnergyValueShowing = true
    private let showEnergyValueButtonAttributes: [NSAttributedString.Key : Any] = [.underlineStyle : 1,
                                                                                   .foregroundColor : SRColors.cherryColor]
    private var energyValueStackViewHeight: CGFloat = 0


    //MARK: - GUI Varibles

    private lazy var productImageView: UIImageView = {
        let productImageView = UIImageView()
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 5
        productImageView.layer.borderColor = SRColors.cherryLightColor.cgColor
        productImageView.image = UIImage(named: "placeholder")
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

    private lazy var productCountWeightLabel: SRLabel = {
        let productCountWeightLabel = SRLabel()
        productCountWeightLabel.text = "Количество|вес:"
        return productCountWeightLabel
    }()

    private lazy var nameCountWeightStackView: UIStackView = {
        let nameCountWeightStackView = UIStackView()
        nameCountWeightStackView.axis = .vertical
        return nameCountWeightStackView
    }()

    private lazy var productCompositionLabel: SRLabel = {
        let productCompositionLabel = SRLabel()
        productCompositionLabel.text = "Состав продукта:"
        productCompositionLabel.numberOfLines = 0
        productCompositionLabel.lineBreakMode = .byWordWrapping
        return productCompositionLabel
    }()

    private lazy var showEnergyValueToggleButton: UIButton = {
        let showEnergyValueButton = UIButton()
        let title = NSMutableAttributedString(string: "Показать энергетическую ценность")
        title.addAttributes(showEnergyValueButtonAttributes, range: NSRange(location: 0, length: title.length))
        showEnergyValueButton.setAttributedTitle(title, for: .normal)
        showEnergyValueButton.addTarget(self, action: #selector(showEnergyValueToggleDidTapped), for: .touchUpInside)
        return showEnergyValueButton
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
        productQuantityStackView.axis = .horizontal
        productQuantityStackView.spacing = 8
        return productQuantityStackView
    }()

    private lazy var addToCartButton: SRButton = {
        let addToCartButton = SRButton()
        addToCartButton.configuration?.title = "Добавить в корзину"
        addToCartButton.addTarget(self, action: #selector(addToCartButtonDidTapped), for: .touchUpInside)
        return addToCartButton
    }()



    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        configureControllerAppearance()
        setFields(with: shownProduct)
    }

    private func configureControllerAppearance() {
        if let product = shownProduct {
            title = product.name
        } else {
            title = "Информация о продукте"
        }

        let textAttributes = [NSAttributedString.Key.foregroundColor: SRColors.cherryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = SRColors.whiteColor
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func addSubviews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(addToCartButton)

        nameCountWeightStackView.addArrangedSubview(productNameLabel)
        nameCountWeightStackView.addArrangedSubview(productCountWeightLabel)
        contentView.addSubview(nameCountWeightStackView)
        contentView.addSubview(productCompositionLabel)
        contentView.addSubview(showEnergyValueToggleButton)

        productEnergyValueStackView.addArrangedSubview(productProteinsLabel)
        productEnergyValueStackView.addArrangedSubview(productFatsLabel)
        productEnergyValueStackView.addArrangedSubview(productCarbohydratesLabel)
        productEnergyValueStackView.addArrangedSubview(productCaloriesLabel)
        contentView.addSubview(productEnergyValueStackView)

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

        nameCountWeightStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(productImageView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }

        productCompositionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(nameCountWeightStackView.snp.bottom).offset(8)
        }

        showEnergyValueToggleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(productCompositionLabel.snp.bottom).offset(8)
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
            energyValueStackViewHeight = productEnergyValueStackView.frame.height
            contentView.layoutIfNeeded()
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {

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

                self.productEnergyValueStackView.snp.makeConstraints { make in
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
                    make.height.equalTo(self.energyValueStackViewHeight)
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
            )

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
        productProteinsLabel.text = "Белки: \(String(format: "%.2f", product.proteins)) г/порция"
        productFatsLabel.text = "Жиры: \(String(format: "%.2f", product.fats))  г/порция"
        productCarbohydratesLabel.text = "Углеводы: \(String(format: "%.2f", product.carbohydrates)) г/порция"
        productCaloriesLabel.text = "\(String(format: "%.2f", product.calories)) калорий в порции"
    }

    //MARK: - User Interation

    private func changeShowEnergyValueToggleTitle() {
        if isEnergyValueShowing {
            let title = NSMutableAttributedString(string: "Показать энергетическую ценность")
            title.addAttributes(showEnergyValueButtonAttributes, range: NSRange(location: 0, length: title.length))
            showEnergyValueToggleButton.setAttributedTitle(title, for: .normal)
        } else {
            let title = NSMutableAttributedString(string: "Скрыть энергетическую ценность")
            title.addAttributes(showEnergyValueButtonAttributes, range: NSRange(location: 0, length: title.length))
            showEnergyValueToggleButton.setAttributedTitle(title, for: .normal)
        }
    }

    private func increaseProductQuantity() {
        if productQuantityCounter < 100 {
            productQuantityCounter += 1
            productQuantityLabel.text = String(productQuantityCounter)
        } else {
            showAlert(title: "Максимальное количество товара", message: "Для оптовой закупки свяжитесь с менджерами")
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

    @objc private func showEnergyValueToggleDidTapped() {
        openCloseEnergyValue()
        changeShowEnergyValueToggleTitle()
    }

    @objc private func addToCartButtonDidTapped() {
        guard let navigationController = tabBarController?.viewControllers?[TabBarTabs.cart.rawValue] as? UINavigationController,
              let cartViewController = navigationController.topViewController as? CartViewController else { return }
        cartViewController.tableViewDataSource.addProductToCart(product: shownProduct, quantity: productQuantityCounter) {
            self.showAlert(title: "Лимит на заказ", message: "Для покупки более 100 единиц товара свяжитесь с менджерами")

        }
    }
}
