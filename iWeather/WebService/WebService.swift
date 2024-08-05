//
//  WebService.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import UIKit

enum WError: Error {
    case NetworkError
}

typealias WeatherClosure = ((WeatherService?) -> ())

class APIService :  NSObject {
    
    func apiToGetWeatherData(city: String, success : @escaping WeatherClosure, failure: @escaping ((WError) -> ())){
        let cityStr = WeatherConstants.Urls.weatherURL.replacingOccurrences(of: "%@", with: city)
        guard let city = cityStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let cityUrl = URL(string: city) else {
            return
        }
        var request = URLRequest(url: cityUrl)
        request.httpMethod = "GET"
        callApi(type: WeatherService.self, requests: request) { result in
            switch result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error as! WError)
            }
        }
    }
    
    func getCities(completion : @escaping (City) -> () )  {
        guard let url = Bundle.main.url(forResource: "CityJson", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let cityList = try! jsonDecoder.decode(City.self, from: data)
            completion(cityList)
        } catch {
            print("Error!! Unable to parse json")
        }
        return
    }
    
}

extension APIService {
    
    func callApi<T: Decodable>(type: T.Type, requests: URLRequest?, completion : @escaping (Result<T, Error>) -> Void) {
        guard let requests = requests else {
            return
        }
        URLSession.shared.dataTask(with: requests) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let data = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(WError.NetworkError))
                }
            } else {
                completion(.failure(WError.NetworkError))
            }
        }.resume()
    }
    
}
