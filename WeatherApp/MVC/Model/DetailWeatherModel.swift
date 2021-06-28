//
//  DetailWeatherModel.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 25.06.2021.
//

import Foundation

public struct ThreeHourWeather: Codable {
    public var date: String
    public var temp: Double
    public var id : Int
}

public struct DetailWeatherModel: Codable, WeatherModelProtocol {
    public var cityName: String
    public var forecastCounter: Int
    public var forecast: [ThreeHourWeather]
    
}
