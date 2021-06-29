//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//

import Foundation

protocol NetworkManagerDelegate {
    func didUpdateWeather(_ weatherManager:NetworkManager, weather: WeatherModelProtocol)
    func didFailWithError(error: Error)
}


struct NetworkManager {
    enum WeatherRequestType {
        case short
        case long
        case onecall
    }
    
    let errorCodeValues: Set = ["400", "401", "404"]
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=daa4c78470b0f95d11bd75012915ce23&units=metric"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    var delegate: NetworkManagerDelegate?
    
    func fetchWeather(for location: String, type: WeatherRequestType) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        switch type {
        case .short:
            components.path = "/data/2.5/weather"
        case .long:
            components.path = "/data/2.5/forecast"
        case .onecall:
            components.path = "/data/2.5/onecall"
        }
        components.queryItems = [
            URLQueryItem(name: "appid", value: API.key),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "q", value: location)
        ]
        if let url = components.url {
            perfomRequest(with: url, type: type)
        }
    }
    
    func fetchShortWeather(cityName: String) {
        print("Fetching weather for \(cityName)")
    }
    
    func perfomRequest(with url: URL, type: WeatherRequestType) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData, type: type) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
    }
    
    func parseJSON(_ weatherData: Data, type: WeatherRequestType) -> WeatherModelProtocol? {
        let decoder = JSONDecoder()
        do {
            print("trying to decode")
            var decodedData: WeatherDataProtocol
            var weatherToReturn: WeatherModelProtocol? = nil
            switch type {
            case .short:
                decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            case .long:
                decodedData = try decoder.decode(DetailWeatherData.self, from: weatherData)
            case .onecall:
                // TODO: Create onecall data struct
                decodedData = try decoder.decode(DetailWeatherData.self, from: weatherData)
                break
            }
            let cod = decodedData.cod
            print(cod as Any)
            if let codValue = cod?.value {
                print(codValue)
                guard !errorCodeValues.contains(codValue) else {
                print("City not found")
                DispatchQueue.main.async {
                    let error = NSError(domain: "", code: 404, userInfo: [ NSLocalizedDescriptionKey: "Error: no data"])
                    delegate?.didFailWithError(error: error)
                }
                return nil
            }
            }
            
            switch type {
            case .short:
                if let decodedData = decodedData as? WeatherData {
                guard let id = decodedData.weather?[0].id else { return nil }
                guard let temp = decodedData.main?.temp else { return nil }
                guard let name = decodedData.name else { return nil }
                guard let country = decodedData.sys?.country else { return nil }
                guard let sunrise = decodedData.sys?.sunrise else { return nil }
                guard let sunset = decodedData.sys?.sunset else { return nil }
                print(decodedData)
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, country: country, sunrise: sunrise, sunset: sunset)
                weatherToReturn = weather
                return weather
                }
            case .long:
                if let decodedData = decodedData as? DetailWeatherData {
                    guard let cityName = decodedData.city?.name else { return nil }
                    guard let forecastCounter = decodedData.cnt else { return nil }
                    guard let forecast = decodedData.list else { return nil }
                    var forecastsArray = [ThreeHourWeather]()
                    for entity in forecast {
                        if let date = entity.dtTxt, let temp = entity.main?.temp, let id = entity.weather?[0].id {
                        let threeHourWeather = ThreeHourWeather(date: date, temp: temp, id: id)
                            forecastsArray.append(threeHourWeather)
                        }
                    }
                    let weather = DetailWeatherModel(cityName: cityName, forecastCounter: forecastCounter, forecast: forecastsArray)
                    print(weather)
                    weatherToReturn = weather
                    return weather
                }
            case .onecall:
                break
            }
            return weatherToReturn
        } catch {
//            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}




