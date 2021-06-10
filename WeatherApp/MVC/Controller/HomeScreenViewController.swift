//
//  HomeScreenViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 10.06.2021.
//


import UIKit
import Foundation



class HomeScreenViewController: UIViewController {
    
    private var networkManager = NetworkManager()
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var weatherIconView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var cityNameLabel: UILabel!
    

    @IBOutlet weak var searchTextField: UITextField!
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    networkManager.delegate = self
    searchTextField.delegate = self
    weatherIconView.image = UIImage(systemName: "sun.min")
    
    NotificationCenter.default.addObserver(self, selector: #selector(loadCityFromUserDefaults), name: UIApplication.willEnterForegroundNotification, object: nil)
    if self.traitCollection.userInterfaceStyle == .light {
        self.view.backgroundColor = .white
    }
    if let city = userDefaults.object(forKey: "City") as? String {
        print("Updating for \(city) cause found in userDefaults")
        networkManager.fetchWeather(cityName: city)
            }


    weatherIconView.image = UIImage(systemName: "sun.min")

  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        if let city = userDefaults.object(forKey: "City") as? String {
            print("Updating for \(city) cause found in userDefaults")
            networkManager.fetchWeather(cityName: city)
                }
    }
  
}

extension HomeScreenViewController: UITextFieldDelegate {
        
        @IBAction func searchButtonPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            } else {
                textField.placeholder = "Enter city name..."
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let city = searchTextField.text{
                networkManager.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
        }
        
    }

extension HomeScreenViewController: NetworkManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.weatherIconView.image = UIImage(systemName: weather.conditionName)
            self.cityNameLabel.text = weather.cityName + "" + self.getFlag(from: weather.country)
            self.userDefaults.set(weather.cityName, forKey: "City")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension HomeScreenViewController {
    func getFlag(from countryCode: String) -> String {

        return countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

extension HomeScreenViewController {
    @objc func loadCityFromUserDefaults() {
//        Todo
    }
}
