//
//  APIServiceTestCase.swift
//  WeatherAppTests
//
//  Created by Kiran Solanke on 19/08/23.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class APIServiceTestCase: XCTestCase {
    
    // API Service
    func testFetchWeatherForCitySuccess() {
        // given
        let json = """
        {"id":1275339,"name":"Mumbai","main":{"temp":28.99},"cod":200}
        """
        let apiServicestub = APIServiceStub()
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
    
    // location service
    
}

class APIServiceStub: APIService {
    var weatherDataToReturn: Data?
    var cityName: String?

    override func fetchWeather(for city: String, completion: @escaping (Result<WeatherApp.WeatherResponse, Error>) -> Void) {
        if let data = weatherDataToReturn {
            let decoder = JSONDecoder()
            do {
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
    
    override func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        if let cityName = cityName {
            completion(cityName)
        }
    }
}
