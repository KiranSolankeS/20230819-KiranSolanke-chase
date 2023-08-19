//
//  ErrorResponse.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 19/08/23.
//

import Foundation

protocol ErrorResponse {
    var message: String? { get }
}

enum CustomIntString: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "invalid")
        }
    }
}
