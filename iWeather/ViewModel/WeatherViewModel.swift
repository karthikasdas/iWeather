//
//  WeatherViewModel.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation
import UIKit

protocol WeatherViewModelProtocol: AnyObject {
    var apiService : APIService? { get set }
    var errorData : WError? { get set }
    var weather : WeatherData? { get set }
    var bindWeatherViewModelToController : ((WeatherData?, WError?) -> ()) { get set }
    
    func callFuncToGetWeatherData(with city: String)
    func loadIcon(with image:String) -> UIImage?
}

class WeatherViewModel : WeatherViewModelProtocol {
    
    internal var apiService : APIService?
    var errorData : WError? {
        didSet {
            self.bindWeatherViewModelToController(nil,errorData)
        }
    }
    var weather : WeatherData? {
        didSet {
            self.bindWeatherViewModelToController(weather,nil)
        }
    }
    
    lazy var bindWeatherViewModelToController : ((WeatherData?, WError?) -> ()) = {_,_  in }
    
    init(with city: String = "") {
        self.apiService =  APIService()
        if !city.isEmpty {
            self.callFuncToGetWeatherData(with: city)
        }
    }
    
    func callFuncToGetWeatherData(with city: String) {
        self.apiService?.apiToGetWeatherData(city: city, success: { weatherData in
            guard let weatherData = weatherData else { return }
            self.weather = self.getWeatherData(from: weatherData)
        }) { error in
            self.errorData = error
        }
    }
    
    private func getWeatherData(from weatherService: WeatherService) -> WeatherData {
        return WeatherData(temperature: String(weatherService.temperature.temp ?? 0.0), cityName: weatherService.name ?? "", minTemperature: String(weatherService.temperature.tempMin ?? 0.0), maxTemperature: String(weatherService.temperature.tempMax ?? 0.0), weather: String(weatherService.weather[0].weather ?? ""), icon: String(weatherService.weather[0].icon ?? ""))
        
    }
    
    func loadIcon(with image: String) -> UIImage? {
        let imageUrl = WeatherConstants.Urls.iconUrl.replacingOccurrences(of: "%@", with: image)
        
        guard let url = URL(string: imageUrl) else { return nil }
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
}
#if DEBUG
extension WeatherViewModel {
    internal func exposeGetWeatherData(from:WeatherService) -> WeatherData {
        return self.getWeatherData(from: from)
    }
}
#endif
