//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import Foundation

extension Double {
    func temperatureString() -> String {
        let degreeSymbol = "\u{00B0}"
        let roundedTemperature = Int(self.rounded())
        return "\(roundedTemperature)\(degreeSymbol)"
    }
}
