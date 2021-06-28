//
//  WeatherDetailedViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 28.06.2021.
//

import UIKit

class WeatherDetailedViewController: UIViewController {

    @IBOutlet weak var detailView: UIView!
    var weatherModel: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailedView = DetailView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        detailedView.weatherModel = weatherModel
        detailedView.resetupView()
        detailView.addSubview(detailedView)


        
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
