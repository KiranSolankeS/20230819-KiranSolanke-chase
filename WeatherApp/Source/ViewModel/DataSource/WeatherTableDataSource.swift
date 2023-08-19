//
//  WeatherTableDataSource.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import UIKit

enum CellType {
    case search
    case location
    case recent
}

final class WeatherTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var data: [(cellType: CellType, content: WeatherResponse)] = []

    func append(obj: (cellType: CellType, content: WeatherResponse)) {
        data.append(obj)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        
        switch item.cellType {
        case .location:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else { return UITableViewCell() }
            cell.setWeather(data: item.content)
            return cell
            
        case .search, .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UITableViewCell() }
            cell.type = item.cellType
            cell.setWeather(data: item.content)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Selected row at index \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data[indexPath.row]
        switch item.cellType {
        case .location:
            return 370.0
        case .search, .recent:
            return 180.0
        }
    }
}
