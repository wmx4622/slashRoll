//
//  SRProduct.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit
import Firebase


typealias Gramm = Int

enum ProductType: Int {
    case roll = 1
    case snack
}

struct SRProduct {
    var productID: String
    var productName: String
    var productCount: Int
    var productWeight: Gramm
    var productPrice: Double
    var productType: ProductType

    static func makeExampleProduct() -> SRProduct {
        SRProduct(productID: "ID", productName: "Example roll", productCount: 8, productWeight: 125, productPrice: 10, productType: .roll)
    }

    static func parseProducts(queryDocumentsArray:[QueryDocumentSnapshot]) -> [SRProduct] {
        var productsArray: [SRProduct] = []
        for document in queryDocumentsArray {
            let product = SRProduct(productID: document.documentID, productName: document["productName"] as? String ?? "", productCount: document["productCount"] as? Int ?? 0, productWeight: document["productWeight"] as? Int ?? 0, productPrice: document["productPrice"] as? Double ?? 0, productType: ProductType(rawValue: document["productCategoryNumber"] as? Int ?? 1) ?? .roll)
            productsArray.append(product)
        }
        return productsArray
    }
}

