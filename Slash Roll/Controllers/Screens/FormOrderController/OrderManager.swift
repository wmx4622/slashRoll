//
//  OrderManager.swift
//  Slash Roll
//
//  Created by Voxar on 22.02.22.
//

import Foundation
import Firebase



class OrderManager {
    //MARK: - Initialization

    required init(orderedProducts: [SRProductInCart]) {
        self.orderedProducts = orderedProducts
    }

    //MARK: - Properties

    private var orderedProducts: [SRProductInCart]

    private lazy var selectedPaymentMethod: PaymentMethods = .cash
    private var selectedPickUpPointID: Int?
    private lazy var selectedDeliveryMethod: DeliveryMethods = .courierDelivery

    //MARK: - User Interaction

    func changePaymentMethod(to paymentMethod: PaymentMethods) {
        selectedPaymentMethod = paymentMethod
    }

    func changeDeliveryMethod(to deliveryMethod: DeliveryMethods) {
        selectedDeliveryMethod = deliveryMethod
    }

    func changePickUpPointID(to pickUpPointID: Int) {
        selectedPickUpPointID = pickUpPointID
    }

    func calculateTotalPrice() -> Double {
        orderedProducts.reduce(0) { partialResult, product in
            partialResult + product.product.price * Double(product.quantity)
        }
    }

    func compliteOrdering(phoneNumber: String?, town: String?, street: String?, building: String?, entrance: String?, floor: String?, flat: String? , comment: String?, callback: @escaping (_ title: String?, _ message: String?, _ isAutorized: Bool?)-> ()) {

        if isOrderInformationValid(phoneNumber: phoneNumber, town: town, street: street, building: building, callback: { title, message in
            callback(title, message, nil)
        }) {
            guard let currentUser = Auth.auth().currentUser else {
                callback(nil, nil, false)
                return
            }

            switch selectedDeliveryMethod {
            case .courierDelivery:
                let order = formOrder(phoneNumber: phoneNumber ?? "", town: town ?? "", street: street ?? "", building: building ?? "", entrance: entrance ?? "", floor: floor ?? "", flat: flat ?? "", comment: comment ?? "")
                sendOrder(order: order, userID: currentUser.uid) { title, message in
                    callback(title, message, nil)
                }
            case .pickup:
                let order = formOrder(phoneNumber: phoneNumber ?? "", pickUpPointID: selectedPickUpPointID ?? 0, comment: comment ?? "")
                sendOrder(order: order, userID: currentUser.uid) { title, message in
                    callback(title, message, nil)
                }
            }
        }
    }

    //MARK: - Forming orders methods

    private func getStringFromDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormater.string(from: Date())
        return dateString
    }

    private func getDictionaryFromOrderedProducts(orderedProducts: [SRProductInCart]) -> [String: Int] {
        var orderedProductsDictionary: [String:Int] = [:]
        orderedProducts.forEach {
            orderedProductsDictionary.updateValue($0.quantity, forKey: $0.product.id)
        }

        return orderedProductsDictionary
    }

    private func formOrder(phoneNumber: String, town: String, street: String, building: String, entrance: String, floor: String, flat: String, comment: String) -> SROrder {

        let address = "Город \(town), Улица \(street),  Дом \(building), Подъезд \(entrance), Этаж \(floor), Квартира \(flat)"
        let order = SROrder(phoneNumber: phoneNumber, deliveryAddress: address, deliveryPaymentMethod: selectedPaymentMethod, deliveryComment: comment, deliveryProducts: getDictionaryFromOrderedProducts(orderedProducts: orderedProducts), totalPrice: calculateTotalPrice(), orderedDate: getStringFromDate())
        return order
    }

    private func formOrder(phoneNumber: String, pickUpPointID: Int, comment: String) -> SROrder {
        let order = SROrder(phoneNumber: phoneNumber, pickUpPointID: pickUpPointID, deliveryPaymentMethod: selectedPaymentMethod, deliveryComment: comment, deliveryProducts: getDictionaryFromOrderedProducts(orderedProducts: orderedProducts), totalPrice: calculateTotalPrice(), orderedDate: getStringFromDate())
        return order
    }

    private func isOrderInformationValid(phoneNumber: String?, town: String? = nil, street: String? = nil, building: String? = nil, callback:(_ title:String, _ massage:String)-> ()) -> Bool {
        guard let phoneNumber = phoneNumber else { return false }

        if phoneNumber.count < 17 {
            callback("Ошибка", "Некорректный номер телефона")
            return false
        }

        if selectedDeliveryMethod == .pickup {
            guard let _ = selectedPickUpPointID else {
                callback("Ошибка", "Выберите пункт самовывоза")
                return false
            }
        }

        if selectedDeliveryMethod == .courierDelivery {
            guard let town = town,
                  let street = street,
                  let building = building else { return false }

            if town.isEmpty {
                callback("Ошибка", "Введите город")
                return false
            }

            if street.isEmpty {
                callback("Ошибка", "Введите улицу")
                return false
            }

            if building.isEmpty {
                callback("Ошбика", "Введите номер дома")
                return false
            }
        }

        return true
    }

//MARK: - Firebase requests

    private func sendOrder(order: SROrder, userID: String,  callback: @escaping (_ title: String, _ message: String) -> ()) {
        let orders = Firestore.firestore().collection(DatabaseCollectionsNames.orders.rawValue)
        let userOrders = orders.document(userID)
        let orderData: [String: Any] = [
            order.orderDate: [
                DatabaseOrderFieldNames.phoneNumber.rawValue: order.phoneNumber,
                DatabaseOrderFieldNames.deliveryMethod.rawValue: order.deliveryMethod.rawValue,
                DatabaseOrderFieldNames.deliveryAddress.rawValue: order.deliveryAddress as Any,
                DatabaseOrderFieldNames.pickUpPointID.rawValue: order.pickUpPointID as Any,
                DatabaseOrderFieldNames.deliveryPaymentMethod.rawValue: order.deliveryPaymentMethod.rawValue,
                DatabaseOrderFieldNames.deliveryComment.rawValue: order.deliveryComment,
                DatabaseOrderFieldNames.deliveryProducts.rawValue: order.deliveryProducts,
                DatabaseOrderFieldNames.totalPrice.rawValue: order.totalPrice,
                DatabaseOrderFieldNames.orderDate.rawValue: order.orderDate,
            ]
        ]

        userOrders.setData(orderData, merge: true) { error in
            if let error = error {
                callback("Ошибка", error.localizedDescription)
            } else {
                callback("", "Заказ оформлен")
            }
        }
    }
}
