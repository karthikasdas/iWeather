//
//  iWeatherMockService.swift
//  iWeatherTests
//
//  Created by Karthika on 04/08/2024.
//

@testable import iWeather

class MockService: APIService {
    
    var mockResponse: WeatherService = WeatherService(cod: 200, weather: [Weather(icon: "04d",weather: "Cloudy")], temperature: Temperature(temp: 30.0,tempMin: 28.0,tempMax: 31.0), name: "Atlanta")
    var webServiceSuccess:Bool?
    
    init(webService: Bool = true) {
        self.webServiceSuccess = webService
    }
    
    override func apiToGetWeatherData(city: String, success : @escaping WeatherClosure, failure: @escaping ((WError) -> ())){
        if let webServiceSuccess = webServiceSuccess, webServiceSuccess == true {
            success(mockResponse)
        } else {
            failure(.NetworkError)
        }
    }
    
}
    
