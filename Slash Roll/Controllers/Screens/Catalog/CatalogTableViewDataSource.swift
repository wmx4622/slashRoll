//
//  CatalogTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit


class CatalogTableViewDataSource: NSObject, UITableViewDataSource {

    private lazy var productsFromDatabase = Array(repeating: SRProduct.makeExampleProduct(), count: 20) // вернуть lazy
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

    func filterProducts(by name: String) {
       if name.isEmpty {
           shownProducts = productsFromDatabase
       } else {
           shownProducts = productsFromDatabase.filter({ product in
               product.productName.lowercased().contains(name.lowercased())
           })
       }
    }
}
