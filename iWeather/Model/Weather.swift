//
//  Weather.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation

struct Weather: Decodable {
    var icon: String?
    var weather: String?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case weather = "main"
    }
}

struct Temperature: Decodable {
    var temp: Float?
    var tempMin: Float?
    var tempMax: Float?
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WeatherData: Decodable {
    var temperature: String
    var cityName: String
    var minTemperature: String
    var maxTemperature: String
    var weather: String
    var icon: String
    
    init(temperature: String, cityName: String, minTemperature: String, maxTemperature: String, weather: String, icon: String) {
        self.temperature = temperature
        self.cityName = cityName
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.weather = weather
        self.icon = icon
    }

}

struct ServerError: Decodable {
    var cod:Int
    var message:String
}

struct WeatherService: Decodable {

    var cod: Int
    var weather: [Weather]
    var temperature: Temperature
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case cod, weather, name
        case temperature = "main"
    }
}
