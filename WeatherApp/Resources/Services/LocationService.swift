//
//  LocationService.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func start(completion: @escaping (CLLocation) -> Void) {
        locationUpdateHandler = completion
        handleLocationAuthorizationStatus()
    }
    
    private func handleLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
        locationManager.stopUpdatingLocation()
    }
}
