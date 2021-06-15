//
//  HomeScreenTableViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 11.06.2021.
//

import Foundation
import UIKit
import CoreData

class HomeScreenTableViewCell: UITableViewCell {
   
//    private let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: self.layer)
            gradientLayer.frame = self.bounds
        }
}

class HomeScreenTableViewController: UITableViewController, NetworkManagerDelegate   {
    private var locations = Locations(locations: [])
    
    
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel) {
        locations.locations.append(weather)
        
        print("Appended weather for \(weather.cityName), reloading data")
        DispatchQueue.main.async {
            self.save(location: weather)
            self.tableView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
//    MARK: SAVE
    func save(location: WeatherModel) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Locations",
                                   in: managedContext)!
        
      
      let weather = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      weather.setValue(locations, forKeyPath: "weatherModel")
      
      // 4
      do {
//        locations.locations.append(location)
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    
    private var networkManager = NetworkManager()
//    private let userDefaults = UserDefaults.standard
    
//    var locations: [WeatherModel] = []
    
    @IBOutlet weak var addCityButton: UIBarButtonItem!
    
    @IBAction func addCity(_ sender: Any) {
        
            let alertController = UIAlertController(title: "Add new location", message: "", preferredStyle: .alert)
               alertController.addTextField { (textField : UITextField!) -> Void in
                   textField.placeholder = "Enter location name..."
               }
               let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                   let firstTextField = alertController.textFields![0] as UITextField
                
                guard let textField = alertController.textFields?.first,
                      let textToSave = firstTextField.text else {
                        return
                    }
                self.networkManager.fetchWeather(cityName: textToSave)
//                self.locations.append(WeatherModel(conditionId: 200, cityName: textToSave, temperature: 0, country: "Test"))

                print("Location: \(firstTextField.text ?? "EMPTY_LOCATION") entered")
               })
               let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
               

               alertController.addAction(saveAction)
               alertController.addAction(cancelAction)
               
               self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! HomeScreenTableViewCell
        cell.cityNameLabel.text = locations.locations[indexPath.row].cityName + "" + self.getFlag(from: locations.locations[indexPath.row].country ?? "")
        cell.weatherIconView.image =  UIImage(systemName: locations.locations[indexPath.row].conditionName)
        cell.temperatureLabel.text = locations.locations[indexPath.row].temperatureString
        
        cell.contentView.applyGradient()

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return  locations.locations.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    networkManager.delegate = self

    
    self.tableView.rowHeight = 60.0
    title = "Locations"
    NotificationCenter.default.addObserver(self, selector: #selector(sendAlert(_:)), name: NSNotification.Name("didReceive404Error"), object: nil)
//    networkManager.delegate = self

    
    if self.traitCollection.userInterfaceStyle == .light {
        self.view.backgroundColor = .white
    }
//    if let city = userDefaults.object(forKey: "City") as? String {
//        print("Updating for \(city) cause found in userDefaults")
//        networkManager.fetchWeather(cityName: city)
//            }
  }
//    MARK: LOAD
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
      
      //3
      do {
        let result = try managedContext.fetch(fetchRequest)
        
        var i = 0
        for data in result as! [NSManagedObject] {
            let mLocations = data.value(forKey: "weatherModel") as! Locations
                        print(" range batch : \(i)")
            for element in mLocations.locations {
                print("location:\(element.cityName)")
                locations.locations.append(element)
                        }
                        i = i + 1
                    }
                    
                    
//                    let cmsg = result.first as! CrewMessage
        
//        locations = try managedContext.fetch(fetchRequest)

      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }


  
}

//extension HomeScreenTableViewController: UITextFieldDelegate {
//
//        @IBAction func searchButtonPressed(_ sender: UIButton) {
//            searchTextField.endEditing(true)
//        }
//
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            searchTextField.endEditing(true)
//            return true
//        }
//
//        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//            if textField.text != "" {
//                return true
//            } else {
//                textField.placeholder = "Enter city name..."
//                return false
//            }
//        }
//
//        func textFieldDidEndEditing(_ textField: UITextField) {
//
//            if let city = searchTextField.text{
//                networkManager.fetchWeather(cityName: city)
//            }
//            searchTextField.text = ""
//        }
//
//    }

//extension HomeScreenTableViewController: NetworkManagerDelegate {
//
//    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel) {
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = weather.temperatureString
//            self.weatherIconView.image = UIImage(systemName: weather.conditionName)
//            self.cityNameLabel.text = weather.cityName + "" + self.getFlag(from: weather.country)
//            self.userDefaults.set(weather.cityName, forKey: "City")
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//
//}


extension HomeScreenTableViewController {
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


extension HomeScreenTableViewController {
    
        @objc func sendAlert(_ notification: Notification?) {
               // [notification name] should always be @"TestNotification"
               // unless you use this method for observation of other notifications
               // as well.
                   print("Successfully received the test notification!")
               
            let alert = UIAlertController(title: "Invalid input", message: "There is no data for entered location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                print("Alert action")
//                self.searchTextField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
}
}

extension UIView {
    func setGradientBackground() {
        
        let colorOne = UIColor(hue: 0.5334009836955244, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        let colorTwo = UIColor(hue: 0.5342215112892978, saturation: 0.0, brightness: 0.8, alpha: 1.0)
        
        
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = self.frame.origin
        let endPoint = CGPoint(x: self.frame.origin.x + self.frame.height, y: self.frame.origin.y + self.frame.width)
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}

//  MARK: Add gradient UIView extension
extension UIView {
    func addGradient(with layer: CAGradientLayer, gradientFrame: CGRect? = nil, colorSet: [UIColor],
                     locations: [Double], startEndPoints: (CGPoint, CGPoint)? = nil) {
        layer.frame = gradientFrame ?? self.bounds
        layer.frame.origin = .zero

        let layerColorSet = colorSet.map { $0.cgColor }
        let layerLocations = locations.map { $0 as NSNumber }

        layer.colors = layerColorSet
        layer.locations = layerLocations

        if let startEndPoints = startEndPoints {
            layer.startPoint = startEndPoints.0
            layer.endPoint = startEndPoints.1
        }

        self.layer.insertSublayer(layer, above: self.layer)
    }
}

// MARK: EX: Get flag emoji
extension HomeScreenTableViewController {
    func getFlag(from countryCode: String) -> String {

        return countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
