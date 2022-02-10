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
    var id: String
    var name: String
    var count: Int
    var weight: Gramm
    var price: Double
    var composition: String
    var imageUrl: String
    var type: ProductType


    static func parseProducts(queryDocumentsArray:[QueryDocumentSnapshot]) -> [SRProduct] {
        var productsArray: [SRProduct] = []
        for document in queryDocumentsArray {
            let product = SRProduct(
                id: document.documentID, name: document[DataBaseDocumentFieldsNames.productName.rawValue] as? String ?? "",
                count: document[DataBaseDocumentFieldsNames.productCount.rawValue] as? Int ?? 0,
                weight: document[DataBaseDocumentFieldsNames.productWeight.rawValue] as? Int ?? 0,
                price: document[DataBaseDocumentFieldsNames.productPrice.rawValue] as? Double ?? 0,
                composition: document[DataBaseDocumentFieldsNames.productComposition.rawValue] as? String ?? "",
                imageUrl: document[DataBaseDocumentFieldsNames.productImageUrl.rawValue] as? String ?? "",
                type: ProductType(rawValue: document[DataBaseDocumentFieldsNames.productCategoryNumber.rawValue] as? Int ?? 1) ?? .roll
            )
            productsArray.append(product)
        }
        return productsArray
    }
}

