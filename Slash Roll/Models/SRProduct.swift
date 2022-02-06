//
//  SRProduct.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit


typealias Gramm = Int

struct SRProduct {
    var productName: String
    var productCount: Int
    var productWeight: Gramm
    var productPrice: Double

    static func makeExampleProduct() -> SRProduct {
         SRProduct(productName: "Example", productCount: 8, productWeight: 125, productPrice: 10)
    }
}
