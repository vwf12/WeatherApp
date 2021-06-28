//
//  WeatherLocationViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 24.06.2021.
//

import UIKit
import Lottie

class WeatherLocationViewController: UIViewController {
    
    
    var location: String = "test"
    private var animationView: AnimationView?

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var cityTemperature: UILabel!
    @IBAction func test(_ sender: Any) {
        print(location)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = location
        animationView = .init(name: "4791-foggy")
        animationView!.frame = lottieView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
        lottieView.addSubview(animationView!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nm = NetworkManager()
        nm.fetchWeather(for: location, type: .long)
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
