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
    navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(.init(horizontal: 10, vertical: 20), for: UIBarMetrics.default)
    title = "WeatherApp"
    NotificationCenter.default.addObserver(self, selector: #selector(sendAlert(_:)), name: NSNotification.Name("didReceive404Error"), object: nil)
    networkManager.delegate = self
    searchTextField.delegate = self
    weatherIconView.image = UIImage(systemName: "sun.min")
    
    if self.traitCollection.userInterfaceStyle == .light {
        self.view.backgroundColor = .white
    }
//    if let city = userDefaults.object(forKey: "City") as? String {
//        print("Updating for \(city) cause found in userDefaults")
//        networkManager.fetchWeather(cityName: city)
//            }

    weatherIconView.image = UIImage(systemName: "sun.min")
    
//    setGradientBackground()
    view.applyGradient()

  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
//        if let city = userDefaults.object(forKey: "City") as? String {
//            print("Updating for \(city) cause found in userDefaults")
//            networkManager.fetchWeather(cityName: city)
//                }
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
            self.cityNameLabel.text = weather.cityName + "" + self.getFlag(from: weather.country ?? "NO_VALUE")
//            self.userDefaults.set(weather.cityName, forKey: "City")
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
    func setGradientBackground() {

        
        
        let colorOne = UIColor(hue: 0.5334009836955244, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        let colorTwo = UIColor(hue: 0.5342215112892978, saturation: 0.0, brightness: 0.8, alpha: 1.0)
        
        
                    
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = self.view.frame.origin
        let endPoint = CGPoint(x: self.view.frame.origin.x + self.view.frame.height, y: self.view.frame.origin.y + self.view.frame.width)
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [colorOne, colorTwo]
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

// MARK: Alert

protocol AlertingViewController {
    func sendAlert()
}

extension HomeScreenViewController {
    
        @objc func sendAlert(_ notification: Notification?) {
               // [notification name] should always be @"TestNotification"
               // unless you use this method for observation of other notifications
               // as well.
                   print("Successfully received the test notification!")
               
            let alert = UIAlertController(title: "Invalid input", message: "There is no data for entered location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                print("Alert action")
                self.searchTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
    
    
}
}

extension Notification.Name {
    static let didReceive404Error = Notification.Name("didReceive404Error")
   
}
