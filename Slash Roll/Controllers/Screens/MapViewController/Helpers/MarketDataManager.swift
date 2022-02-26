//
//  MarketDataManager.swift
//  Slash Roll
//
//  Created by Voxar on 24.02.22.
//

import Foundation
import Firebase


class MarketsDataManager {

    //MARK: - Properties

    private lazy var marketsFromDataBase: [QueryDocumentSnapshot] = []
    private lazy var parsedMarkets: [SRMarket] = []
    private lazy var markets: [SRMarket] = []

    //MARK: - Data access

    func getAllMarkets() -> [SRMarket] {
        markets
    }

    //MARK: - FirebaseRequests

    func loadMarketsList(callback: @escaping () -> ()) {
        let database = Firestore.firestore()
        database.collection(DatabaseCollectionsNames.markets.rawValue).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.marketsFromDataBase = snapshot.documents
            }

            self.markets = SRMarket.parseMarkets(queryDocumentsArray: self.marketsFromDataBase)
            callback()
        }
    }
}

