//
//  ApplyGradient.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 16.06.2021.
//

import Foundation
import UIKit

extension UIView {
    func applyDefaultGradient() {
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
