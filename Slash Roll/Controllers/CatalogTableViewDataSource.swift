//
//  CatalogTableViewDataSource.swift
//  Slash Roll
//
//  Created by Voxar on 4.02.22.
//

import UIKit

class CatalogTableViewDataSource: NSObject, UITableViewDataSource {

    typealias City = String

    private lazy var cities: [City] = ["Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон","Минск", "Москва", "Лондон",]

    func getCity(withID id: Int) -> City {
        cities[id]
    }

    func removeCity(withID id: Int) {
        cities.remove(at: id)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configurator = cell.defaultContentConfiguration()
        configurator.text = cities[indexPath.row]
        cell.contentConfiguration = configurator
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
