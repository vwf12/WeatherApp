//
//  DetailView.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 28.06.2021.
//

import UIKit
import Lottie

class DetailView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var innerBackgoundView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var dateBadgeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    public var weatherModel: WeatherModel? {
        didSet {
            self.resetupView()
        }
    }
    private var animationView: AnimationView?
    private var date: String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd MMMM"
        let dateString = df.string(from: date) + ", " + date.dayOfWeek()!
        return dateString
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func resetupView() {
        setupView(model: weatherModel!)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let weatherModel = weatherModel else { return }
        print("Setting up view")
        setupView(model: weatherModel)
    }
    
    private func setupView(model :WeatherModel) {
        innerBackgoundView.layer.cornerRadius = 10
        innerBackgoundView.layer.shadowColor = UIColor.black.cgColor
        innerBackgoundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        innerBackgoundView.layer.shadowOpacity = 0.7
        innerBackgoundView.layer.shadowRadius = 4.0

        
        dateBadgeView.layer.cornerRadius = 20
        dateBadgeView.layer.borderWidth = 1.0
        dateBadgeView.layer.borderColor = UIColor.black.cgColor
        dateBadgeView.layer.shadowColor = UIColor.black.cgColor
        dateBadgeView.layer.shadowOffset = CGSize(width: 3, height: 3)
        dateBadgeView.layer.shadowOpacity = 0.7
        dateBadgeView.layer.shadowRadius = 4.0
        
        cityLabel.text = model.cityName
        weatherStatus.text = model.conditionName
        temperature.text = model.temperatureString
        dateLabel.text = date
        
        animationView = .init(name: model.lottieConditionName)
        animationView!.frame = lottieView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.animationSpeed = 0.5
        lottieView.addSubview(animationView!)
        animationView!.play()
        
        lottieView.layer.shadowColor = UIColor.white.cgColor
        lottieView.layer.shadowOffset = CGSize(width: 0, height: -20)
        lottieView.layer.shadowOpacity = 0.7
        lottieView.layer.shadowRadius = 4.0
    }
}
