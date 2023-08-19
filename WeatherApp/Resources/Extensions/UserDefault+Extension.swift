//
//  UserDefault+Extension.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 19/08/23.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case lastCitySearched
    }
    
    static var lastSearchedCity: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.lastCitySearched.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.lastCitySearched.rawValue)
        }
    }
}
