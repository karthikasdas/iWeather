//
//  Constants.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation

struct WeatherConstants {
    
    struct Urls {
        static var iconUrl = "https://openweathermap.org/img/wn/%@.png"
        static let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&appid=44f1f74de9ca977976f75d86adfc48cf"
    }
    
    struct ErrorMessages {
        static var locError = "Encountered an issue with city, please make sure location access is permitted."
        static var errorHeader = "Network Error"
        static var generalError = "Encountered a server error"
        static var networkError = "Encountered a network error"
        static var generalErrorHeader = "Error"
        static var cityError = "Please check the city name, no special characters are allowed, and add required white space."
    }
    
    struct Regex {
        static var regex = ".*[^A-Z a-z].*"
    }
    
    struct Names {
        static var weather = "Weather"
        static var weatherCell = "WeatherCell"
        static var cityCell = "CityCell"
        static var degrees = "Degrees"
    }
    
    struct IdentifiersForTest {
        static var weatherCell = "WeatherCell:Cell"
        static var location = "WeatherCell:Location"
        static var weather = "WeatherCell:Weather"
        static var icon = "WeatherCell:Icon"
        static var degrees = "WeatherCell:Degrees"
        static var minMax = "WeatherCell:MinMax"
        static var searchBar = "WeatherCell:SearchBar"
        static var cityTable = "CityTable:Table"
        static var doneButton = "CityTable:DoneButton"
    }
}

enum Requests {
    case str(String)
    case req(URLRequest)
}
