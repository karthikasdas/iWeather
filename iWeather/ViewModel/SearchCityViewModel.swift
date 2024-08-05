//
//  SearchCityViewModel.swift
//  iWeather
//
//  Created by Karthika on 8/2/24.
//

import UIKit

class SearchCityViewModel: NSObject {
    
    var delegate: SearchCityUpdate
    
    private var apiService : APIService!
    private(set) var cityList : [CityModel]! {
        didSet {
            self.delegate.bindVmAndUI(with: cityList)
        }
    }
    
    init(with delegate: SearchCityUpdate) {
        self.delegate = delegate
        super.init()
        self.apiService = APIService()
        self.callApiCityList()
    }
    
    func callApiCityList() {
        self.apiService.getCities { cities in
            var citymodels = [CityModel]()
            cities.results?.forEach({ city in
                let strArray = city.value
                for i in 0..<strArray.count {
                    let city_model = CityModel(cityName: strArray[i])
                    citymodels += [city_model]
                }
            })
            self.cityList = citymodels
        }
    }
}
