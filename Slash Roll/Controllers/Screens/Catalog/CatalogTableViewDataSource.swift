//
//  CatalogTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit


class CatalogTableViewDataSource: NSObject, UITableViewDataSource {

    typealias City = String

    private lazy var Products: [SRProduct] = [SRProduct.makeExampleProduct()]

    func getProduct(withID id: Int) -> SRProduct {
        Products[id]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseIdentifier , for: indexPath) as? CatalogTableViewCell else { return UITableViewCell() }
        cell.setCell(product: Products[indexPath.row])
        return cell
    }
}
