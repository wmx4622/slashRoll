//
//  SROrder.swift
//  Slash Roll
//
//  Created by Voxar on 20.02.22.
//

import Foundation


struct SROrder {
    var isCourierDelivery: Bool
    var phoneNumber: String
    var deliveryAddress: String
    var deliveryPaymentMethodId: Int
    var deliveryComment: String
    var deliveryProduct: [String:Any]
    var orderDate: String

}
