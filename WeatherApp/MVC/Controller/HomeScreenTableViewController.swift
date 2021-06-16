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
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: self.layer)
            gradientLayer.frame = self.bounds
        }
}

class HomeScreenTableViewController: UITableViewController, NetworkManagerDelegate {
    private var locations = Locations(locations: [])
    private var networkManager = NetworkManager()
    
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
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let entity =
        NSEntityDescription.entity(forEntityName: "Locations",
                                   in: managedContext)!
        
      let weather = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      weather.setValue(locations, forKeyPath: "weatherModel")
      
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    @IBOutlet weak var addCityButton: UIBarButtonItem!
//    MARK: Add button
    @IBAction func addCity(_ sender: Any) {
        
            let alertController = UIAlertController(title: "Add new location", message: "", preferredStyle: .alert)
               alertController.addTextField { (textField : UITextField!) -> Void in
                   textField.placeholder = "Enter location name..."
               }
               let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                   let firstTextField = alertController.textFields![0] as UITextField
                
                guard let textToSave = firstTextField.text else {
                        return
                    }
                self.networkManager.fetchWeather(cityName: textToSave)
                print("Location: \(firstTextField.text ?? "EMPTY_LOCATION") entered")
               })
               let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
               alertController.addAction(saveAction)
               alertController.addAction(cancelAction)
               self.present(alertController, animated: true, completion: nil)
        
    }
//    MARK: Create cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! HomeScreenTableViewCell
        cell.cityNameLabel.text = locations.locations[indexPath.row].cityName + "" + self.getFlag(from: locations.locations[indexPath.row].country )
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

    if self.traitCollection.userInterfaceStyle == .light {
        self.view.backgroundColor = .white
    }
  }
//    MARK: LOAD
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let fetchRequest =
        NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
      
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
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
}
// MARK: Alert

extension HomeScreenTableViewController {
        @objc func sendAlert(_ notification: Notification?) {
            print("Successfully received the test notification!")
            let alert = UIAlertController(title: "Invalid input", message: "There is no data for entered location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                print("Alert action")
            }))
            self.present(alert, animated: true, completion: nil)
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
