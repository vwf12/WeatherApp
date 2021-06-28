//
//  HomeScreenTableViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 11.06.2021.
//

import Foundation
import UIKit
import CoreData

class HomeScreenTableViewController: UITableViewController {
    //    MARK: --IBOUtlets--
    @IBOutlet private weak var addCityButton: UIBarButtonItem!
    
    //    MARK: --Properties--
    private var weatherModels = [WeatherModel]()
    private var locations = Locations(locations: [])
    private var locationsStrings = Set<String>()
    private var locationsObjects = [NSManagedObject]()
    private var networkManager = NetworkManager()
    
    //    MARK: --View Livecycle--
    override func viewDidLoad()
    {
        super.viewDidLoad()
        networkManager.delegate = self
        self.tableView.rowHeight = 60.0
        title = "Locations"
        self.loadLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadData()

    }
    
    //    MARK: --View Setup--
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! HomeScreenTableViewCell
        let location = weatherModels[indexPath.row]
        cell.configureCell(for: location)        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
//        return  locations.locations.count
        weatherModels.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = weatherModels[indexPath.row]
        
//        
//        if let viewController = storyboard?.instantiateViewController(identifier: "WeatherLocationViewController") as? WeatherLocationViewController {
//            viewController.location = selectedLocation.cityName
//            navigationController?.pushViewController(viewController, animated: true)
                if let viewController = storyboard?.instantiateViewController(identifier: "WeatherDetailedViewController") as? WeatherDetailedViewController {
                    viewController.weatherModel = selectedLocation
                    navigationController?.pushViewController(viewController, animated: true)
        }
    }
    //    MARK: --IBActions--
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
//            self.networkManager.fetchShortWeather(cityName: textToSave)
            self.networkManager.fetchWeather(for: textToSave, type: .short)
            print("Location: \(firstTextField.text ?? "EMPTY_LOCATION") entered")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Extension: CoreData save/load
extension HomeScreenTableViewController {
    func saveData(location: WeatherModel) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "WeatherModel",
                                       in: managedContext)!
        let weather = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        weather.setValue(locations, forKeyPath: "locations")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveLocationString(location: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Location",
                                       in: managedContext)!
        let locationObject = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        locationObject.setValue(location, forKeyPath: "name")
        do {
            try managedContext.save()
            locationsObjects.append(locationObject)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func loadData() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherModel")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            var i = 0
            for data in result as! [NSManagedObject] {
                let mLocations = data.value(forKey: "locations") as! Locations
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
    
    func loadLocations() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        do {
            locationsObjects = try managedContext.fetch(fetchRequest)
            locationsObjects.forEach({
                if let locationString = $0.value(forKey: "name") as? String {
                    locationsStrings.insert(locationString)
                }
            })
            DispatchQueue.main.async { [weak self] in
                self?.locationsStrings.forEach({
//                    self?.networkManager.fetchShortWeather(cityName: $0)
                    self?.networkManager.fetchWeather(for: $0, type: .short)
                })
            }
            print(locationsStrings)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: Extension: Alert
extension HomeScreenTableViewController {
    @objc func sendAlert() {
        print("Successfully received the test notification!")
        let alert = UIAlertController(title: "Invalid input", message: "There is no data for entered location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            print("Alert action")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Extension:  NetworkManagerDelegate
extension HomeScreenTableViewController: NetworkManagerDelegate {
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModelProtocol) {
        let weatherModel = weather as! WeatherModel
        weatherModels.append(weatherModel)
        print("Appended weather for \(weatherModel.cityName), reloading data")
        DispatchQueue.main.async {
//            self.saveData(location: weather)
            self.saveLocationString(location: weatherModel.cityName)
            self.tableView.reloadData()
        }
    }
    
//    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel) {
////        locations.locations.append(weather)
////        locations.locationStrings.insert(weather.cityName)
//        weatherModels.append(weather)
//        print("Appended weather for \(weather.cityName), reloading data")
//        DispatchQueue.main.async {
////            self.saveData(location: weather)
//            self.saveLocationString(location: weather.cityName)
//            self.tableView.reloadData()
//        }
//    }
    func didFailWithError(error: Error) {
        sendAlert()
        print(error)
    }
}



