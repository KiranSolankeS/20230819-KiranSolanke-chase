//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    var weatherResponse: (([(CellType, WeatherResponse)]) -> Void)?
    var viewState: ((ViewState) -> Void)?
    
    private let weatherService: APIService
    private let locationService: LocationService
    private var isCurrentLocationWeatherFetched = false
    private var cellData: [(cellType: CellType, content: WeatherResponse)] = []

    init(weatherService: APIService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
        
        self.fetchCurrentLocationWeather()
        self.autoLoadLastCitySearched()
    }
    
    func fetchWeatherData(cityName: String, cellType: CellType) {
        weatherService.fetchWeather(for: cityName) { [weak self] result in
            switch result {
            case .success(let response):
                debugPrint("response:\(response)")
                DispatchQueue.main.async {
                    if let msg = response.message {
                        self?.viewState?(.error(msg))
                    } else {
                        self?.processData(type: cellType, response: response)
                    }
                }
            case .failure(let error):
                debugPrint("error:\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.viewState?(.error(error.localizedDescription))
                }
            }
        }
    }

    private func processData(type: CellType, response: WeatherResponse) {
        let item = (type, response)
        switch type {
        case .search:
            cellData.insert(item, at: 0)
        case .location:
            cellData.insert(item, at: 0)
        case .recent:
            cellData.append(item)
        }
        self.weatherResponse?(cellData)
    }
    
    private func fetchCurrentLocationWeather() {
        guard !isCurrentLocationWeatherFetched else { return }
        locationService.start { [weak self] location in
            guard let self = self else { return }
            self.fetchCityName(location: location)
        }
        isCurrentLocationWeatherFetched = true
    }
    
    private func autoLoadLastCitySearched() {
        guard let cityName = UserDefaults.lastSearchedCity else { return }
        fetchWeatherData(cityName: cityName, cellType: .recent)
    }
    
    private func fetchCityName(location: CLLocation) {
        weatherService.fetchCityName(from: location) { [weak self] cityName in
            guard let cityName = cityName else { return }
            self?.fetchWeatherData(cityName: cityName, cellType: .location)
        }
    }
}
