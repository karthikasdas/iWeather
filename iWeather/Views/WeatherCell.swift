//
//  WeatherCell.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var location:UILabel!
    @IBOutlet weak var weather:UILabel!
    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var degrees:UILabel!
    @IBOutlet weak var minMax:UILabel!
    var weatherData: WeatherData? {
        didSet {
            self.location.text = "\(weatherData?.cityName ?? "") "
            self.weather.text = weatherData?.weather
            self.degrees.text = "\(weatherData?.temperature ?? "") \(WeatherConstants.Names.degrees)"
            self.minMax.text = "H: \(weatherData?.maxTemperature ?? "") L: \( weatherData?.minTemperature ?? "")"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setIdentifiers()
    }
    
    func setIdentifiers() {
        self.location.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.location
        self.weather.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.weather
        self.icon.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.icon
        self.degrees.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.degrees
        self.minMax.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.minMax
    }

}
