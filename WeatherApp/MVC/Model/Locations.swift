//
//  DataModel.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 14.06.2021.
//

import Foundation
import CoreData

@objc public class Locations: NSObject, NSCoding, NSFetchRequestResult {
    public var locations: [WeatherModel]
    
    enum Key: String {
        case locations = "locations"
    }
    
    init(locations: [WeatherModel]) {
        self.locations = locations
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(locations, forKey: Key.locations.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mLocations = coder.decodeObject(forKey: Key.locations.rawValue) as! [WeatherModel]
        
        self.init(locations: mLocations)
    }
}

