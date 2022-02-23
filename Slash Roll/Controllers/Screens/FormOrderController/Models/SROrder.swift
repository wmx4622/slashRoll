//
//  SROrder.swift
//  Slash Roll
//
//  Created by Voxar on 20.02.22.
//

import Foundation


struct SROrder {
    var phoneNumber: String
    var deliveryMethod: DeliveryMethods
    var deliveryAddress: String?
    var pickUpPointID: Int?
    var deliveryPaymentMethod: PaymentMethods
    var deliveryComment: String
    var deliveryProducts: [String:Any]
    var totalPrice: Double
    var orderDate: String

    init(phoneNumber: String, deliveryAddress: String, deliveryPaymentMethod: PaymentMethods, deliveryComment: String, deliveryProducts: [String:Any], totalPrice: Double, orderedDate: String) {
        self.phoneNumber = phoneNumber
        self.deliveryMethod = DeliveryMethods.courierDelivery
        self.deliveryAddress = deliveryAddress
        self.deliveryPaymentMethod = deliveryPaymentMethod
        self.deliveryComment = deliveryComment
        self.deliveryProducts = deliveryProducts
        self.totalPrice = totalPrice
        self.orderDate = orderedDate
    }

    init(phoneNumber: String, pickUpPointID: Int, deliveryPaymentMethod: PaymentMethods, deliveryComment: String, deliveryProducts: [String:Any], totalPrice: Double, orderedDate: String) {
        self.phoneNumber = phoneNumber
        self.deliveryMethod = DeliveryMethods.pickup
        self.pickUpPointID = pickUpPointID
        self.deliveryPaymentMethod = deliveryPaymentMethod
        self.deliveryComment = deliveryComment
        self.deliveryProducts = deliveryProducts
        self.totalPrice = totalPrice
        self.orderDate = orderedDate
    }
}
