//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 08.06.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          return navController
      }
    
    
    func setupVCs() {
         viewControllers = [
              createNavController(for: ViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
              createNavController(for: ViewController(), title: NSLocalizedString("My cities", comment: ""), image: UIImage(systemName: "list.bullet")!),
              createNavController(for: ViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!),
            createNavController(for: MapViewController(), title: NSLocalizedString("Map", comment: ""), image: UIImage(systemName: "map")!)
          ]
      }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupVCs()
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
