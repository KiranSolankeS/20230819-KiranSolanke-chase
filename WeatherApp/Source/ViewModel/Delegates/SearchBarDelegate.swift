//
//  SearchBarDelegate.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import UIKit

final class SearchBarDelegate: NSObject, UISearchBarDelegate {
    
    var fetchWeatherFor: ((String?) -> Void)?
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        fetchWeatherFor?(text)
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
