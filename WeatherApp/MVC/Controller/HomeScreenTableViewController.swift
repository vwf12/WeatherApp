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
    private var locations = Locations(locations: [])
    private var networkManager = NetworkManager()
    
    //    MARK: --View Livecycle--
    override func viewDidLoad()
    {
        super.viewDidLoad()
        networkManager.delegate = self
        self.tableView.rowHeight = 60.0
        title = "Locations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    //    MARK: --View Setup--
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! HomeScreenTableViewCell
        let location = locations.locations[indexPath.row]
        cell.configureCell(for: location)        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return  locations.locations.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
            self.networkManager.fetchWeather(cityName: textToSave)
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
    
    func loadData() {
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
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel) {
        locations.locations.append(weather)
        print("Appended weather for \(weather.cityName), reloading data")
        DispatchQueue.main.async {
            self.saveData(location: weather)
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        sendAlert()
        print(error)
    }
}



