//
//  CityResponse.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import Foundation

struct CityResponse: Codable {
    let name: String?
    let latitude: Double?
    let longitude: Double?
    let country: String?
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}
