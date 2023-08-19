//
//  APIService.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import Foundation
import CoreLocation

struct APIEndpoints {
    // Base URL for weather API.
    static var weatherAPIBaseURL: String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    
    // Base URL for geocoding API.
    static var geocodingAPIBaseURL: String {
        return "https://api.openweathermap.org/geo/1.0/reverse"
    }
}

class APIService {
    let apiKey: String
    var weatherUrl: String
    var geoUrl: String
    
    init() {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("Missing APIKey in Info.plist")
        }
        self.apiKey = apiKey
        self.weatherUrl = APIEndpoints.weatherAPIBaseURL
        self.geoUrl = APIEndpoints.geocodingAPIBaseURL
    }
    
    // MARK: - Fetch Weather
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            let error = NSError(domain: "Invalid city name for URL encoding", code: 0)
            completion(.failure(error))
            return
        }
        
        let urlString = "\(weatherUrl)?q=\(encodedCity)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            debugPrint("Invalid weather URL")
            return
        }
        debugPrint("url:\(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    // MARK: - Fetch City Name
    
    func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = "\(geoUrl)?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            debugPrint("Invalid geo URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint("Failed to fetch city name: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                debugPrint("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([CityResponse].self, from: data)
                let cityName = response.first?.name
                completion(cityName)
            } catch {
                debugPrint("Failed to decode response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
