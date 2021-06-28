//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//

import Foundation
import CoreData

protocol WeatherModelProtocol {
    
}



public class WeatherModel: NSObject, NSCoding, WeatherModelProtocol {
    enum DayTime {
        case day
        case night
    }
    
    public var conditionId: Int
    public var cityName: String
    public var temperature: Double
    public var country: String
    public var sunrise: Int
    public var sunset: Int
    
    var dayTime: DayTime {
        let date = Date().timeIntervalSince1970
        if Int(date) < sunset && Int(date) > sunrise {
            return .day
        } else {
            return .night
        }
    }
    
    public var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    public var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    public var lottieConditionName: String {
        switch conditionId {
        case 200...232:
            return "4805-weather-thunder"
        case 300...321:
            switch dayTime {
            case .day:
                return "4803-weather-storm"
            case .night:
                return "4803-weather-storm"
            }
        case 500...531:
            switch dayTime {
            case .day:
                return "4801-weather-partly-shower"
            case .night:
                return "4797-weather-rainynight"
            }
        case 600...622:
            switch dayTime {
            case .day:
                return "4793-weather-snow"
            case .night:
                return "4798-weather-snownight"
            }
        case 701...781:
            switch dayTime {
            case .day:
                return "4795-weather-mist"
            case .night:
                return "4795-weather-mist"
            }
        case 800:
            switch dayTime {
            case .day:
                return "4804-weather-synny"
            case .night:
                return "4799-weather-night"
            }
        case 801...804:
            switch dayTime {
            case .day:
                return "4806-weather-windy"
            case .night:
                return "4796-weather-cloudynight"
            }
        default:
            return "4791-foggy"
        }
    }
    
    enum Key: String {
        case conditionId = "conditionId"
        case cityName = "cityName"
        case temperature = "temperature"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
    
    init(conditionId: Int, cityName: String, temperature: Double, country: String, sunrise: Int, sunset: Int) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(conditionId, forKey: Key.conditionId.rawValue)
        coder.encode(cityName, forKey: Key.cityName.rawValue)
        coder.encode(temperature, forKey: Key.temperature.rawValue)
        coder.encode(country, forKey: Key.country.rawValue)
        coder.encode(sunrise, forKey: Key.sunrise.rawValue)
        coder.encode(sunset, forKey: Key.sunset.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mConditionId = coder.decodeInteger(forKey: Key.conditionId.rawValue)
        let mCityName = coder.decodeObject(forKey: Key.cityName.rawValue) as? String ?? ""
        let mTemperature = coder.decodeDouble(forKey: Key.temperature.rawValue)
        let mCountry = coder.decodeObject(forKey: Key.country.rawValue) as? String ?? ""
        let mSunset = coder.decodeDouble(forKey: Key.sunset.rawValue)
        let mSunrise = coder.decodeDouble(forKey: Key.sunrise.rawValue)
        
        self.init(conditionId: mConditionId, cityName: mCityName, temperature: mTemperature, country: mCountry, sunrise: Int(mSunrise), sunset: Int(mSunset))
    }
    

}
