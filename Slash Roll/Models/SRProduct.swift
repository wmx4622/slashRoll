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
    var image: UIImage?
    var imageUrl: String
    var type: ProductType
    var proteins: Double
    var fats: Double
    var carbohydrates: Double
    var calories: Double

    static func parseProducts(queryDocumentsArray:[QueryDocumentSnapshot]) -> [SRProduct] {
        var productsArray: [SRProduct] = []

        for document in queryDocumentsArray {
            let product = SRProduct(
                id: document.documentID, name: document[DataBaseProductFieldsNames.productName.rawValue] as? String ?? "",
                count: document[DataBaseProductFieldsNames.productCount.rawValue] as? Int ?? 0,
                weight: document[DataBaseProductFieldsNames.productWeight.rawValue] as? Int ?? 0,
                price: document[DataBaseProductFieldsNames.productPrice.rawValue] as? Double ?? 0,
                composition: document[DataBaseProductFieldsNames.productComposition.rawValue] as? String ?? "",
                imageUrl: document[DataBaseProductFieldsNames.productImageUrl.rawValue] as? String ?? "",
                type: ProductType(rawValue: document[DataBaseProductFieldsNames.productCategoryNumber.rawValue] as? Int ?? 1) ?? .roll,
                proteins: document[DataBaseProductFieldsNames.productProteins.rawValue] as? Double ?? 0,
                fats: document[DataBaseProductFieldsNames.productFats.rawValue] as? Double ?? 0,
                carbohydrates: document[DataBaseProductFieldsNames.productCarbohydrates.rawValue] as? Double ?? 0,
                calories: document[DataBaseProductFieldsNames.productCalories.rawValue] as? Double ?? 0
            )

            productsArray.append(product)
        }

        return productsArray
    }
}

