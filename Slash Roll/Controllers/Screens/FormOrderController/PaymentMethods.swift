//
//  PaymentMethods.swift
//  Slash Roll
//
//  Created by Voxar on 20.02.22.
//

import Foundation


enum PaymentMethods {
    case cash
    case card

    var info: (id: Int, description: String) {
        switch self {
        case .cash:
            return (0, "Наличными")
        case .card:
            return (1,"Картой")
        }
    }
}


