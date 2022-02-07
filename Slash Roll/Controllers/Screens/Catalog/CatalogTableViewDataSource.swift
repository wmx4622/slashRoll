//
//  CatalogTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit


class CatalogTableViewDataSource: NSObject, UITableViewDataSource {

    private lazy var productsFromDatabase = [SRProduct(productName: "Имбирь ролл", productCount: 20, productWeight: 200, productPrice: 30, productType: .roll), SRProduct.init(productName: "Имбирь", productCount: 1, productWeight: 20, productPrice: 3, productType: .snack), SRProduct(productName: "Шеф-ролл", productCount: 5, productWeight: 100, productPrice: 15, productType: .roll), SRProduct(productName: "Соевый соус", productCount: 1, productWeight: 90, productPrice: 6, productType: .snack)]

    private lazy var shownProducts: [SRProduct] = productsFromDatabase

    func getProduct(withID id: Int) -> SRProduct {
        shownProducts[id]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shownProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseIdentifier , for: indexPath) as? CatalogTableViewCell else { return UITableViewCell() }
        cell.setCell(product: shownProducts[indexPath.row])
        return cell
    }

    func filterProducts(by name: String, productCategoryNumber: Int) {
        switch (name.isEmpty, productCategoryNumber == 0) {
        case (true, true):
            shownProducts = productsFromDatabase

        case(true, false):
            shownProducts = productsFromDatabase.filter { product in
                product.productType.rawValue == productCategoryNumber
            }
            
        case(false, true):
            shownProducts = productsFromDatabase.filter { product in
                product.productName.lowercased().contains(name.lowercased())
            }

        case(false, false):
            shownProducts = productsFromDatabase.filter { product in
                product.productName.lowercased().contains(name.lowercased()) && product.productType.rawValue == productCategoryNumber
            }
        }
    }
}
