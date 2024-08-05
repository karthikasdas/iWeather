//
//  CityCell.swift
//  iWeather
//
//  Created by Karthika on 03/08/2024.

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCityName(city: String) {
        self.cityName.text = city
    }
    
}
