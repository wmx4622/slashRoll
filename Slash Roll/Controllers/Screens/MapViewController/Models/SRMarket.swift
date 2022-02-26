//
//  SRMarket.swift
//  Slash Roll
//
//  Created by Voxar on 24.02.22.
//

import Foundation
import Firebase


struct SRMarket {
    var name: String
    var latitude: Double
    var longitude: Double
    var workingHours: String
    var address: String

    static func parseMarkets(queryDocumentsArray:[QueryDocumentSnapshot]) -> [SRMarket] {

        var markets: [SRMarket] = []

        for document in queryDocumentsArray {
            let market = SRMarket(
                name: document[DataBaseMarketFields.name.rawValue] as? String ?? "Название",
                latitude: document[DataBaseMarketFields.latitude.rawValue] as? Double ?? 53.9,
                longitude: document[DataBaseMarketFields.longitude.rawValue] as? Double ?? 27.56,
                workingHours: document[DataBaseMarketFields.workingHours.rawValue] as? String ?? "Часы работы",
                address: document[DataBaseMarketFields.address.rawValue] as? String ?? "Адрес"
            )

            markets.append(market)
        }

        return markets
    }
}


