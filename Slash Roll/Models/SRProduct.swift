//
//  SRProduct.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit


typealias Gramm = Int

enum ProductType: Int {
    case roll = 1
    case snack
}

struct SRProduct {
    var productName: String
    var productCount: Int
    var productWeight: Gramm
    var productPrice: Double
    var productType: ProductType
    static func makeExampleProduct() -> SRProduct {
        SRProduct(productName: "Example roll", productCount: 8, productWeight: 125, productPrice: 10, productType: .roll)
    }
}
