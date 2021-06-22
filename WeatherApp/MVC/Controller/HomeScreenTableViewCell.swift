//
//  HomeScreenTableViewCell.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 22.06.2021.
//

import Foundation
import UIKit

class HomeScreenTableViewCell: UITableViewCell {
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherIconView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    let gradientLayer = CAGradientLayer()
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = self.bounds
    }
    
    func configureCell(for location: WeatherModel) {
        self.cityNameLabel.text = location.cityName + "" + self.getFlag(from: location.country )
        self.weatherIconView.image =  UIImage(systemName: location.conditionName)
        self.temperatureLabel.text = location.temperatureString
        self.contentView.applyDefaultGradient()
    }
}

// MARK: Extension:  Get flag emoji
extension HomeScreenTableViewCell {
    func getFlag(from countryCode: String) -> String {
        return countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
