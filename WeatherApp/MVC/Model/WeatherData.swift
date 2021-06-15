//
//  WeatherData.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//


import Foundation

// MARK: - Welcome
struct WeatherData: Codable {
    let message: String?
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: RelaxedString?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}


extension WeatherData {
    struct RelaxedString: Codable {
        let value: String

        init(_ value: String) {
            self.value = value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            // attempt to decode from all JSON primitives
            if let str = try? container.decode(String.self) {
                value = str
            } else if let int = try? container.decode(Int.self) {
                value = int.description
            } else if let double = try? container.decode(Double.self) {
                value = double.description
            } else if let bool = try? container.decode(Bool.self) {
                value = bool.description
            } else {
                throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
}
