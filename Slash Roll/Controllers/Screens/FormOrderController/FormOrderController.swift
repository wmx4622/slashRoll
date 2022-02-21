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
    private var courierDeliveryStackViewHeight: CGFloat = 220

    private let pickUpPointSelectionButtonAttibutes = [NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.foregroundColor : SRColors.cherryColor] as [NSAttributedString.Key : Any]

    var orderedProducts: [SRProductInCart] = Array(repeating: SRProductInCart(product: SRProduct(id: "1", name: "1", count: 1, weight: 1, price: 1, composition: "1", image: nil, imageUrl: "", type: .roll, proteins: 1, fats: 1, carbohydrates: 1, calories: 1), quantity: 5), count: 5)

    private lazy var selectedPaymentMethod: PaymentMethods = .cash
    private lazy var isCourierDelivery: Bool = true

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
        pickUpPointSelectionButton.setAttributedTitle(title, for: .normal)

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
            print(alertViewController.selectedComponent)
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
        }

        compliteOrderButton.snp.makeConstraints { make in
            make.top.equalTo(totalOrderedProductsPriceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    @objc private func deliveryMethodDidChanged(sender: SRSegmentedControl) {

        switch sender.selectedSegmentIndex {
        case DeliveryMethods.pickup.rawValue:

            pickUpPointSelectionButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(16)//jj
                make.leading.equalToSuperview().inset(8)
            }

            pickUpPointSelectionButton.isHidden = false

            paymentMethodLabel.snp.makeConstraints { make in
                make.top.equalTo(pickUpPointSelectionButton.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(8)
            }

            courierDeliveryFlatField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryFloorField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryEntranceField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryBuildingField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryStreetField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            courierDeliveryTownField.snp.makeConstraints { make in
                make.height.equalTo(0)
            }
//
            courierDeliveryStackView.snp.makeConstraints { make in
                make.height.equalTo(0)
            }

            isCourierDelivery.toggle()

        case DeliveryMethods.courierDelivery.rawValue:

            courierDeliveryFlatField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryFloorField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryEntranceField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryBuildingField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryStreetField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }

            courierDeliveryTownField.snp.remakeConstraints { make in
                make.height.equalTo(30)
            }


            courierDeliveryStackView.snp.remakeConstraints { make in
                make.top.equalTo(phoneNumberTextField.snp.bottom).offset(8)
                make.height.equalTo(courierDeliveryStackViewHeight)
                make.leading.trailing.equalToSuperview().inset(8)
            }

            paymentMethodLabel.snp.remakeConstraints { make in
                make.top.equalTo(courierDeliveryStackView.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(8)
            }



            pickUpPointSelectionButton.isHidden = true

            isCourierDelivery.toggle()

        default:
            break
        }
    }
    //MARK: - Firebase requests


    private func formOrder() -> SROrder {
        let address = "Город \(courierDeliveryTownField.text ?? ""), Улица \(courierDeliveryStreetField.text ?? ""),  Сооружение \(courierDeliveryBuildingField.text ?? ""), Подъезд \(courierDeliveryEntranceField.text ?? ""), Этаж \(courierDeliveryFloorField.text ?? ""), Квартира \(courierDeliveryFlatField.text ?? "" )"
        let order = SROrder(isCourierDelivery: deliveryMethodSegmentedControl.selectedSegmentIndex == 0, phoneNumber: phoneNumberTextField.text ?? "", deliveryAddress: address, deliveryPaymentMethodId: 1, deliveryComment: orderCommentTextView.text ?? "", deliveryProduct: getDictionaryFromOrderedProducts(), orderDate: getStringFromDate())
        return order
    }

    private func getStringFromDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yy"
        let dateString = dateFormater.string(from: Date())
        return dateString
    }

    private func getDictionaryFromOrderedProducts() -> [String: Int] {
        var orderedProductsDictionary: [String:Int] = [:]
        orderedProducts.forEach {
            orderedProductsDictionary.updateValue($0.quantity, forKey: $0.product.id)
        }
        return orderedProductsDictionary
    }

    private func sendOrder() {
        let database = Firestore.firestore()
        let newOrder = formOrder()
        let orderData: [String:Any] = [
            newOrder.orderDate: [
                "date": newOrder.orderDate,
                "phoneNumber": newOrder.phoneNumber,
                "address": newOrder.deliveryAddress,
                "deliveryPaymentMethod": newOrder.deliveryPaymentMethodId,
                "deliveryComment": newOrder.deliveryComment,
                "deliveryProducts": newOrder.deliveryProduct

            ]
        ]

        database.collection("orders").document("test").setData(orderData)
    }

    @objc private func sendOrderButtonDidTapped() {
        present(pickupPointAlert, animated: true, completion: nil)
    }

}

