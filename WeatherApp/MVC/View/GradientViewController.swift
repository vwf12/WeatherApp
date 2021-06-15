//
//  GradientViewController.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 10.06.2021.
//

import UIKit

class GradientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    func setGradientBackground() {
        let gradient: CAGradientLayer = {
            let colorOne = UIColor(hue: 0.5334009836955244, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            let colorTwo = UIColor(hue: 0.5342215112892978, saturation: 0.0, brightness: 0.8, alpha: 1.0).cgColor
            
            let gradient = CAGradientLayer()
            gradient.type = .axial
            gradient.colors = [
                colorOne, colorTwo
            ]
//            gradient.locations = [0, 0.25, 1]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            return gradient
        }()
        gradient.frame = view.bounds
        self.view.layer.addSublayer(gradient)
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

extension UIView {
    func applyGradient() {
         layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let colorOne = UIColor(hue: 0.5334009836955244, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
        let colorTwo = UIColor(hue: 0.5342215112892978, saturation: 0.0, brightness: 0.8, alpha: 1.0).cgColor
        
         let gradientLayer = CAGradientLayer()
        
         gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
         
         backgroundColor = .clear
         gradientLayer.frame = bounds
         layer.insertSublayer(gradientLayer, at: 0)
     }

}
