//
//  City.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation

struct City: Decodable {
    var results: [String:[String]]?
}

class CityModel {
    var cityName: String
    var selected = false
    init(cityName: String, selected: Bool = false) {
        self.cityName = cityName
        self.selected = selected
    }
}

