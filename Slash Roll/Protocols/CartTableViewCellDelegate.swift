//
//  CartTableViewCellDelegate.swift
//  Slash Roll
//
//  Created by Voxar on 18.02.22.
//

import Foundation

protocol CartTableViewCellDelegate: AnyObject {
    func addProductToCart(product: SRProduct?, quantity: Int, callback: (()->())?)
}
