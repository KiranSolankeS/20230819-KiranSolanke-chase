//
//  LocationAPIServiceTestCase.swift
//  WeatherAppTests
//
//  Created by Kiran Solanke on 19/08/23.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class LocationAPIServiceTestCase: XCTestCase {
    
    // location API
    func testFetchWeatherForLocationSuccess() {
        // given
        let json = """
        [{"name":"Mumbai"}]
        """
        let apiServicestub = LocationAPIServiceStub()
        apiServicestub.cityData = json.data(using: .utf8)
        let location = CLLocation(latitude: 19.0144, longitude: 72.8479)

        // when
        let expectation = XCTestExpectation(description: "Fetch weather for location success")
        
        apiServicestub.fetchCityName(from: location) { cityName in
            //then
            XCTAssertNotNil(cityName)
            XCTAssertEqual(cityName, "Mumbai")
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFetchWeatherForLocationFailure() {
        // given
        let json = """
        []
        """
        let apiServicestub = LocationAPIServiceStub()
        apiServicestub.cityData = json.data(using: .utf8)
        let location = CLLocation(latitude: 00.0000, longitude: 00.0000) // not passing proper co-ordinates

        // when
        let expectation = XCTestExpectation(description: "Fetch weather for location failure")
        
        apiServicestub.fetchCityName(from: location) { cityName in
            //then
            XCTAssertNil(cityName)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
}

class LocationAPIServiceStub: APIService {
    var cityData: Data?
    
    override func fetchCityName(from location: CLLocation, completion: @escaping (String?) -> Void) {
        if let data = cityData {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([CityResponse].self, from: data)
                let cityName = response.first?.name
                completion(cityName)
            } catch {
                debugPrint("Failed to decode response: \(error)")
                completion(nil)
            }
        }
    }
}
