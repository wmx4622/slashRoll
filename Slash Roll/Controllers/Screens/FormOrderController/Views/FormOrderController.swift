//
//  FormOrderController.swift
//  Slash Roll
//
//  Created by Voxar on 19.02.22.
//

import UIKit
import Firebase


class FormOrderController: SRScrollableViewController {

    //MARK: - Properties

    required init(orderedProducts: [SRProductInCart]) {
        super.init(nibName: nil, bundle: nil)
        self.orderedProducts = orderedProducts
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var orderedProducts: [SRProductInCart] = []
    private lazy var orderManager = OrderManager(orderedProducts: orderedProducts)
    private var courierDeliveryStackViewHeight: CGFloat = 0
    private let pickUpPointSelectionButtonAttibutes = [NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.foregroundColor : SRColors.cherryColor] as [NSAttributedString.Key : Any]

    //MARK: - GUI varibles

    private lazy var deliveryMethodLabel: SRLabel = {
        let deliveryMethodLabel = SRLabel()
        deliveryMethodLabel.text = "Способ доставки:"
        return deliveryMethodLabel
    }()

    private lazy var deliveryMethodSegmentedControl: SRSegmentedControl = {
        let deliveryMethodSegmentedControl = SRSegmentedControl(frame: CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 150, height: 150)))
        deliveryMethodSegmentedControl.insertSegment(withTitle: "Доставка", at: 0, animated: false)
        deliveryMethodSegmentedControl.insertSegment(withTitle: "Самовывоз", at: 1, animated: false)
        deliveryMethodSegmentedControl.addTarget(self, action: #selector(deliveryMethodDidChanged), for: .valueChanged)
        deliveryMethodSegmentedControl.selectedSegmentIndex = 0
        return deliveryMethodSegmentedControl
    }()

    private lazy var phoneNumberTextField: SRTextField = {
        let phoneNumberTextField = SRTextField()
        phoneNumberTextField.placeholder = "Номер телефона"
        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.smartInsertDeleteType = .no
        phoneNumberTextField.returnKeyType = .next
        return phoneNumberTextField
    }()

    private lazy var pickUpPointSelectionButton: UIButton = {
        let pickUpPointSelectionButton = UIButton()
        pickUpPointSelectionButton.isHidden = true
        let title = NSMutableAttributedString(string: "Пункт самовывоза:")
        title.addAttributes(pickUpPointSelectionButtonAttibutes, range: NSRange(location: 0, length: title.length))
        pickUpPointSelectionButton.addTarget(self, action: #selector(pickUpPointSelectionButtonDidTapped), for: .touchUpInside)
        pickUpPointSelectionButton.setAttributedTitle(title, for: .normal)
        pickUpPointSelectionButton.titleLabel?.lineBreakMode = .byTruncatingHead
        return pickUpPointSelectionButton
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

    private lazy var pickupPointAlert: UIAlertController = {
        let pickupAlert = UIAlertController(title: "Выберите магазин самовывоза", message: "", preferredStyle: .alert)

        pickupAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        let alertViewController = PickUpPointPickerPopup()
        pickupAlert.setValue(alertViewController, forKey: "contentViewController")
        pickupAlert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { _ in
            self.orderManager.changePickUpPointID(to: alertViewController.selectedComponent)
            let pickUpPointName = alertViewController.getPickUpPointName(with: alertViewController.selectedComponent)
            let title = NSMutableAttributedString(string: "Пункт самовывоза:\(pickUpPointName)")
            title.addAttributes(self.pickUpPointSelectionButtonAttibutes, range: NSRange(location: 0, length: title.length))
            self.pickUpPointSelectionButton.setAttributedTitle(title, for: .normal)


        }))
        alertViewController.preferredContentSize = .init(width: view.bounds.width, height: 300)
        return pickupAlert
    }()

    private lazy var paymentMethodLabel: SRLabel = {
        let paymentMethodLabel = SRLabel()
        paymentMethodLabel.text = "Способ оплаты:"
        return paymentMethodLabel
    }()

    private lazy var paymentMethodSegmentedControl: SRSegmentedControl = {
        let paymentMethodSegmentedControl = SRSegmentedControl(frame: CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 150, height: 150)))
        paymentMethodSegmentedControl.addTarget(self, action: #selector(paymentMethodDidChanged), for: .valueChanged)
        paymentMethodSegmentedControl.insertSegment(withTitle: "Наличными", at: 0, animated: false)
        paymentMethodSegmentedControl.insertSegment(withTitle: "Картой", at: 1, animated: false)
        paymentMethodSegmentedControl.selectedSegmentIndex = 0
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
        totalOrderedProductPriceLabel.lineBreakMode = .byTruncatingHead
        totalOrderedProductPriceLabel.text = "Общая стоимость корзины: \(String(format: "%.2f", orderManager.calculateTotalPrice())) руб"

        return totalOrderedProductPriceLabel
    }()

    private lazy var compliteOrderButton: SRButton = {
        let compliteOrderButton = SRButton()
        compliteOrderButton.configuration?.title = "Оформить заказ"
        compliteOrderButton.addTarget(self, action: #selector(sendOrderButtonDidTapped), for: .touchUpInside)
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
        contentView.addSubview(pickUpPointSelectionButton)
        contentView.addSubview(courierDeliveryStackView)
        contentView.addSubview(orderCommentTextViewDescriptionLabel)
        contentView.addSubview(paymentMethodLabel)
        contentView.addSubview(paymentMethodSegmentedControl)
        contentView.addSubview(orderCommentTextView)
        contentView.addSubview(totalOrderedProductsPriceLabel)
        contentView.addSubview(compliteOrderButton)
    }

    //MARK: - Layout Configuration

    private func configureLayout() {

        deliveryMethodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
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

        pickUpPointSelectionButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(8)
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
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }

        compliteOrderButton.snp.makeConstraints { make in
            make.top.equalTo(totalOrderedProductsPriceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    //MARK: - User Interaction

    @objc private func deliveryMethodDidChanged(sender: SRSegmentedControl) {
        view.endEditing(true)

        switch sender.selectedSegmentIndex {
        case DeliveryMethods.pickup.rawValue:


            courierDeliveryStackViewHeight = courierDeliveryStackView.frame.height

            pickUpPointSelectionButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(16)

                make.leading.equalToSuperview().inset(8)
                make.trailing.lessThanOrEqualToSuperview().inset(8)
            }

            pickUpPointSelectionButton.isHidden = false

            paymentMethodLabel.snp.makeConstraints { make in
                make.top.equalTo(pickUpPointSelectionButton.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(8)
            }

            courierDeliveryFlatField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryTownField.isHidden = true

            courierDeliveryFloorField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryFloorField.isHidden = true

            courierDeliveryEntranceField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryEntranceField.isHidden = true

            courierDeliveryBuildingField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryBuildingField.isHidden = true

            courierDeliveryStreetField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryStreetField.isHidden = true

            courierDeliveryTownField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryTownField.isHidden = true

            orderManager.changeDeliveryMethod(to: .pickup)

        case DeliveryMethods.courierDelivery.rawValue:

            courierDeliveryFlatField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryFlatField.isHidden = false


            courierDeliveryFloorField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryFloorField.isHidden = false

            courierDeliveryEntranceField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryEntranceField.isHidden = false

            courierDeliveryBuildingField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryBuildingField.isHidden = false

            courierDeliveryStreetField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryStreetField.isHidden = false

            courierDeliveryTownField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryTownField.isHidden = false

            paymentMethodLabel.snp.remakeConstraints { make in
                make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(8)
            }

            pickUpPointSelectionButton.isHidden = true
            orderManager.changeDeliveryMethod(to: .courierDelivery)

        default:
            break
        }
    }

    @objc private func pickUpPointSelectionButtonDidTapped() {
        present(pickupPointAlert, animated: true, completion: nil)
    }

    @objc private func paymentMethodDidChanged(sender: SRSegmentedControl) {
        PaymentMethods.allCases.forEach { element in
            if element.rawValue == sender.selectedSegmentIndex {
                orderManager.changePaymentMethod(to: element)
            }
        }
    }

    @objc private func sendOrderButtonDidTapped() {

        orderManager.compliteOrdering(phoneNumber: phoneNumberTextField.text, town: courierDeliveryTownField.text, street: courierDeliveryStreetField.text, building: courierDeliveryBuildingField.text, entrance: courierDeliveryEntranceField.text, floor: courierDeliveryFloorField.text, flat: courierDeliveryFlatField.text, comment: orderCommentTextView.text) { [weak self] title, message, isAutorize in

            if isAutorize == false {
                self?.present(AuthorizationViewController(), animated: true, completion: nil)
            }

            if let title = title, let message = message {
                self?.showAlert(title: title, message: message)
            }
        }
    }
}

//MARK: - Extensions

extension FormOrderController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        switch textField {

        case self.phoneNumberTextField:
            guard let phoneNumber = textField.text,
                  let rangeOfTextToReplace = Range(range, in: phoneNumber) else { return true }
            let formattedText = phoneNumber.applyPatternOnNumbers(pattern: "# (###) ###-##-##", replacmentCharacter: "#")
            let substringToReplace = phoneNumber[rangeOfTextToReplace]
            let count = phoneNumber.count - substringToReplace.count + string.count
            textField.text = formattedText
            return count <= 17
        default: return true
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField {

        case self.phoneNumberTextField:
            guard let phoneNumber = textField.text, phoneNumber.isEmpty else { return true }
            textField.text = "8 (0"
            let end = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: end, to: end)
        default: return true
        }

        return true
    }

}
