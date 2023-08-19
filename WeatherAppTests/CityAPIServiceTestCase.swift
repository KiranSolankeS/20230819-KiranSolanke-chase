//
//  CityAPIServiceTestCase.swift
//  WeatherAppTests
//
//  Created by Kiran Solanke on 19/08/23.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class CityAPIServiceTestCase: XCTestCase {
    
    // City API
    func testFetchWeatherForCitySuccess() {
        // given
        let json = """
        {"id":1275339,"name":"Mumbai","main":{"temp":28.99},"cod":200}
        """
        let apiServicestub = CityAPIServiceStub()
        apiServicestub.weatherDataToReturn = json.data(using: .utf8)
        
        // when
        let expectation = XCTestExpectation(description: "Fetch weather for city success")
        
        apiServicestub.fetchWeather(for: "Mumbai") { result in
            // then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.id, 1275339)
                XCTAssertEqual(response.name, "Mumbai")
            case .failure(_):
                debugPrint("Not execute this")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFetchWeatherForCityFailure() {
        // given
        let json = """
        {"cod":"404","message":"city not found"}
        """
        let apiServicestub = CityAPIServiceStub()
        apiServicestub.weatherDataToReturn = json.data(using: .utf8)
        
        // when
        let expectation = XCTestExpectation(description: "Fetch weather for city failure")
        
        apiServicestub.fetchWeather(for: "Pu") { result in
            // then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.message, "city not found")
            case .failure(_):
                debugPrint("Not execute this")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
}

class CityAPIServiceStub: APIService {
    var weatherDataToReturn: Data?

    override func fetchWeather(for city: String, completion: @escaping (Result<WeatherApp.WeatherResponse, Error>) -> Void) {
        if let data = weatherDataToReturn {
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        } else {
            let error = NSError(domain: "No data found", code: 0000)
            completion(.failure(error))
        }
    }
}
