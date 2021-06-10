//
//  HomeScreenViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 10.06.2021.
//


import UIKit
import Foundation



class HomeScreenViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    @IBOutlet weak var weatherIconView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var cityNameLabel: UILabel!
    

    @IBOutlet weak var searchTextField: UITextField!
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    if self.traitCollection.userInterfaceStyle == .light {
        self.view.backgroundColor = .white
    }

//    self.view.backgroundColor = self.traitCollection.userInterfaceStyle == .dark : .black ? .white
    networkManager.delegate = self
    searchTextField.delegate = self
    weatherIconView.image = UIImage(systemName: "sun.min")

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
            self.cityNameLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
