//
//  FormOrderController.swift
//  Slash Roll
//
//  Created by Voxar on 19.02.22.
//

import UIKit


class FormOrderController: SRScrollableViewController {

    //MARK: - Properties

    var orderedProducts: [SRProductInCart] = Array(repeating: SRProductInCart(product: SRProduct(id: "1", name: "1", count: 1, weight: 1, price: 1, composition: "1", image: nil, imageUrl: "", type: .roll, proteins: 1, fats: 1, carbohydrates: 1, calories: 1), quantity: 5), count: 5)

    //MARK: - GUI varibles

    private lazy var deliveryMethodLabel: SRLabel = {
        let deliveryMethodLabel = SRLabel()
        deliveryMethodLabel.text = "Выберите способ доставки:"
        return deliveryMethodLabel
    }()

    private lazy var deliveryMethodSegmentedControl: SRSegmentedControl = {
        let deliveryMethodSegmentedControl = SRSegmentedControl(frame: CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 150, height: 150)))
        deliveryMethodSegmentedControl.insertSegment(withTitle: "Доставка", at: 0, animated: false)
        deliveryMethodSegmentedControl.insertSegment(withTitle: "Самовывоз", at: 1, animated: false)
        return deliveryMethodSegmentedControl
    }()

    private lazy var phoneNumberTextField: SRTextField = {
        let phoneNumberTextField = SRTextField()
        phoneNumberTextField.placeholder = "Номер телефона"
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.smartInsertDeleteType = .no
        phoneNumberTextField.returnKeyType = .next
        return phoneNumberTextField
    }()

    private lazy var courierDeliveryTownField: SRTextField = {
        let courierDeliveryTownLabel = SRTextField()
        courierDeliveryTownLabel.placeholder = "Город доставки"
        courierDeliveryTownLabel.returnKeyType = .next
        return courierDeliveryTownLabel
    }()

    private lazy var courierDeliveryStreetField: SRTextField = {
        let courierDeliveryStreetField = SRTextField()
        courierDeliveryStreetField.placeholder = "Улица"
        courierDeliveryStreetField.returnKeyType = .next
        return courierDeliveryStreetField
    }()

    private lazy var courierDeliveryBuildingField: SRTextField = {
        let courierDeliveryBuildingField = SRTextField()
        courierDeliveryBuildingField.placeholder = "Дом"
        courierDeliveryBuildingField.returnKeyType = .next
        return courierDeliveryBuildingField
    }()

    private lazy var courierDeliveryEntranceField: SRTextField = {
        let courierDeliveryEntranceField = SRTextField()
        courierDeliveryEntranceField.placeholder = "Подъезд"
        courierDeliveryEntranceField.returnKeyType = .next
        return courierDeliveryEntranceField
    }()

    private lazy var courierDeliveryFloorField: SRTextField = {
        let courierDeliveryFloorField = SRTextField()
        courierDeliveryFloorField.placeholder = "Этаж"
        courierDeliveryFloorField.returnKeyType = .next
        return courierDeliveryFloorField
    }()

    private lazy var courierDeliveryFlatField: SRTextField = {
        let courierDeliveryFlatField = SRTextField()
        courierDeliveryFlatField.placeholder = "Квартира"
        courierDeliveryFlatField.returnKeyType = .next
        return courierDeliveryFlatField
    }()

    private lazy var courierDeliveryStackView: UIStackView = {
        let courierDeliveryStackView = UIStackView()
        courierDeliveryStackView.axis = .vertical
        courierDeliveryStackView.spacing = 8
        courierDeliveryStackView.addArrangedSubview(courierDeliveryTownField)
        courierDeliveryStackView.addArrangedSubview(courierDeliveryStreetField)
        courierDeliveryStackView.addArrangedSubview(courierDeliveryBuildingField)
        courierDeliveryStackView.addArrangedSubview(courierDeliveryEntranceField)
        courierDeliveryStackView.addArrangedSubview(courierDeliveryFloorField)
        courierDeliveryStackView.addArrangedSubview(courierDeliveryFlatField)
        return courierDeliveryStackView
    }()

    private lazy var paymentMethodLabel: SRLabel = {
        let paymentMethodLabel = SRLabel()
        paymentMethodLabel.text = "Выберите способ оплаты:"
        return paymentMethodLabel
    }()

    private lazy var paymentMethodSegmentedControl: SRSegmentedControl = {
        let paymentMethodSegmentedControl = SRSegmentedControl(frame: .zero)
        paymentMethodSegmentedControl.insertSegment(withTitle: "Наличными", at: 0, animated: false)
        paymentMethodSegmentedControl.insertSegment(withTitle: "Картой", at: 1, animated: false)
        return paymentMethodSegmentedControl
    }()

    private lazy var orderCommentTextViewDescriptionLabel: SRLabel = {
        let orderCommentTextViewDescriptionLabel = SRLabel()
        orderCommentTextViewDescriptionLabel.text = "Комментарий к заказу"
        return orderCommentTextViewDescriptionLabel
    }()

    private lazy var orderCommentTextView: UITextView = {
        let orderCommentTextView = UITextView()
        orderCommentTextView.backgroundColor = SRColors.cherryLightColor
        orderCommentTextView.layer.cornerRadius = 8
        orderCommentTextView.textColor = SRColors.whiteColor
        orderCommentTextView.tintColor = SRColors.whiteColor
        orderCommentTextView.font = .systemFont(ofSize: 16)
        return orderCommentTextView
    }()

    private lazy var totalOrderedProductsPriceLabel: SRLabel = {
        let totalOrderedProductPriceLabel = SRLabel()
        totalOrderedProductPriceLabel.text = "Общая стоимость корзины:"
        return totalOrderedProductPriceLabel
    }()

    private lazy var compliteOrderButton: SRButton = {
        let compliteOrderButton = SRButton()
        compliteOrderButton.configuration?.title = "Оформить заказ"
        return compliteOrderButton
    }()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SRColors.whiteColor
        addSubviews()
        configureLayout()
        addKeyboardListener(lastViewFrame: compliteOrderButton.frame)


    }

    private func addSubviews() {
        contentView.addSubview(deliveryMethodLabel)
        contentView.addSubview(deliveryMethodSegmentedControl)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(courierDeliveryStackView)
        contentView.addSubview(paymentMethodLabel)
        contentView.addSubview(paymentMethodSegmentedControl)
        contentView.addSubview(orderCommentTextViewDescriptionLabel)
        contentView.addSubview(orderCommentTextView)
        contentView.addSubview(totalOrderedProductsPriceLabel)
        contentView.addSubview(compliteOrderButton)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {

        deliveryMethodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(8)
        }

        deliveryMethodSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(deliveryMethodLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(deliveryMethodSegmentedControl.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        courierDeliveryStackView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        paymentMethodLabel.snp.makeConstraints { make in
            make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(8)
        }

        paymentMethodSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(paymentMethodLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }


        orderCommentTextViewDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentMethodSegmentedControl.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(8)

        }

        orderCommentTextView.snp.makeConstraints { make in
            make.top.equalTo(orderCommentTextViewDescriptionLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(50)
        }

        totalOrderedProductsPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(orderCommentTextView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(8)
        }

        compliteOrderButton.snp.makeConstraints { make in
            make.top.equalTo(totalOrderedProductsPriceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
