//
//  CartTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartTableViewDataSource: NSObject, UITableViewDataSource {

    private lazy var productsInCart: [SRProductInCart] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        cell.setCell(cartItem: productsInCart[indexPath.row])
        return cell
    }

    
}
