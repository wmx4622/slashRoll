//
//  CatalogTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit
import FirebaseFirestore


class CatalogTableViewDataSource: NSObject, UITableViewDataSource {

    //MARK: - Properties

    private lazy var productsFromDatabase: [QueryDocumentSnapshot] = []
    private lazy var parsedProducts: [SRProduct] = [] {
        didSet {
            shownProducts = parsedProducts
        }
    }

    private lazy var shownProducts: [SRProduct] = []

    //MARK: - DataSource

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

    //MARK: - Filtring

    func filterProducts(by name: String, productCategoryNumber: Int) {
        switch (name.isEmpty, productCategoryNumber == 0) {
        case (true, true):
            shownProducts = parsedProducts

        case(true, false):
            shownProducts = parsedProducts.filter { product in
                product.type.rawValue == productCategoryNumber
            }

        case(false, true):
            shownProducts = parsedProducts.filter { product in
                product.name.lowercased().contains(name.lowercased())
            }

        case(false, false):
            shownProducts = parsedProducts.filter { product in
                product.name.lowercased().contains(name.lowercased())
                && product.type.rawValue == productCategoryNumber
            }
        }
    }

    //MARK: - Firebase Requests

    func loadProductList(callback: @escaping () -> ()) {
        let database = Firestore.firestore()
        database.collection(DatabaseCollectionsNames.products.rawValue).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.productsFromDatabase = snapshot.documents
            }

            self.parsedProducts = SRProduct.parseProducts(queryDocumentsArray: self.productsFromDatabase)
            callback()
        }
    }
}
