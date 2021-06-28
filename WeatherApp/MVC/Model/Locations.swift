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
    @NSManaged public var locationStringsData: [String]
    
//    var locationStrings : [String] {
//        get {
//            let data = Data(locationStringsData.utf8)
//            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
//        }
//        set {
//            guard let data = try? JSONEncoder().encode(newValue),
//                let string = String(data: data, encoding: .utf8) else { locationStringsData = ""
//                return
//            }
//            locationStringsData = string
//        }
//    }
    
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

