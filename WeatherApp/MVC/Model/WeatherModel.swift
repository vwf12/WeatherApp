//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//

import Foundation
import CoreData

public class WeatherModel: NSObject, NSCoding {
    public var conditionId: Int
    public var cityName: String
    public var temperature: Double
    public var country: String
    
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
    
    enum Key: String {
        case conditionId = "conditionId"
        case cityName = "cityName"
        case temperature = "temperature"
        case country = "country"
    }
    
    init(conditionId: Int, cityName: String, temperature: Double, country: String) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
        self.country = country
    }
    
//    public override init() {
//        super.init()
//    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(conditionId, forKey: Key.conditionId.rawValue)
        coder.encode(cityName, forKey: Key.cityName.rawValue)
        coder.encode(temperature, forKey: Key.temperature.rawValue)
        coder.encode(country, forKey: Key.country.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mConditionId = coder.decodeInteger(forKey: Key.conditionId.rawValue)
        let mCityName = coder.decodeObject(forKey: Key.cityName.rawValue) as? String ?? ""
        let mTemperature = coder.decodeDouble(forKey: Key.temperature.rawValue)
        let mCountry = coder.decodeObject(forKey: Key.country.rawValue) as? String ?? ""
        
        self.init(conditionId: mConditionId, cityName: mCityName, temperature: mTemperature, country: mCountry)
    }
    

}
