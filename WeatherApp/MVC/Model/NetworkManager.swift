//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//

import Foundation

protocol NetworkManagerDelegate {
    func didUpdateWeather(_ weatherManager:NetworkManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct NetworkManager {
    

    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=daa4c78470b0f95d11bd75012915ce23&units=metric"
    var delegate: NetworkManagerDelegate?
    
    func fetchWeather(cityName: String) {
        print("Fetching weather for \(cityName)")
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlstring: String) {
        
        if let url = URL(string: urlstring) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let country = decodedData.sys.country
            print(decodedData)
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, country: country)
            return weather
        
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}

