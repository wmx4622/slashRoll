//
//  CartTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 16.02.22.
//

import UIKit


class CartTableViewDataSource: NSObject, UITableViewDataSource, CartTableViewCellDelegate {
    //MARK: - Properties

    private lazy var productsInCart: [SRProductInCart] = []

    //MARK: - DataSource

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        cell.setCell(cartItem: productsInCart[indexPath.row])
        cell.delegate = self
        cell.product = productsInCart[indexPath.row].product
        return cell
    }

    func addProductToCart(product: SRProduct?, quantity: Int, callback: (()->())? = nil) {
        guard let product = product else { return }
        
        if productsInCart.filter({ $0.product.id == product.id }).count == 0 {
            let addedProduct = SRProductInCart(product: product, quantity: quantity)
            productsInCart.append(addedProduct)
        } else {
            for (index, item) in productsInCart.enumerated() {
                if item.product.id == product.id {
                    if (item.quantity + quantity) <= 100 {
                    productsInCart[index].quantity += quantity

                    } else {
                        if let callback = callback {
                            callback()
                        }
                    }
                }
            }
        }
    }

    func isCartEmpty() -> Bool {
        productsInCart.isEmpty
    }

    func deleteProduct(with id: Int) {
        productsInCart.remove(at: id)
    }

    func getProduct(with id: Int) -> SRProductInCart {
        productsInCart[id]
    }
}
