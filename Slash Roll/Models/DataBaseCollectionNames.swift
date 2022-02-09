//
//  Network Manager.swift
//  Slash Roll
//
//  Created by Voxar on 8.02.22.
//

import Foundation
import Firebase

enum DatabaseCollectionsName: String {
    case products
}



class NetworkManager {
    typealias DataBaseAnswer = Result<([QueryDocumentSnapshot]), Error>
    func getData(completionHandler:((DataBaseAnswer) -> Void)?)  {
        func completionHandlerMain(_ result: DataBaseAnswer) {
            DispatchQueue.main.async {
                completionHandler?(result)
            }
        let db = Firestore.firestore()
//        var parsedProducts: [SRProduct] = []
//        var product = SRProduct()
        db.collection(DatabaseCollectionsName.products.rawValue).getDocuments { snapshot, error in
            if let error = error {
                completionHandlerMain(.failure(error))
            } else if let snapshot = snapshot {
                completionHandlerMain(.success(snapshot.documents))
            }
        }
    }

}
}
