//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import Foundation

struct WeatherResponse: Codable, ErrorResponse {
    var message: String?
    
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: CustomIntString
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try container.decodeIfPresent(Coord.self, forKey: .coord)
        weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        base = try container.decodeIfPresent(String.self, forKey: .base)
        main = try container.decodeIfPresent(Main.self, forKey: .main)
        visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
        dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        if let intValue = try? container.decode(Int.self, forKey: .cod) {
            cod = .integer(intValue)
        } else if let stringValue = try? container.decode(String.self, forKey: .cod) {
            cod = .string(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .cod, in: container, debugDescription: "Invalid value")
        }
    }
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
