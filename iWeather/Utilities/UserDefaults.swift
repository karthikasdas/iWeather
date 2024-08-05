//
//  UserDefaults.swift
//  iWeather
//
//  Created by Karthika on 03/08/2024.
//

import Foundation


class SaveCityName: NSObject {
    
    static var storedCityName: String? {
        get {
            return UserDefaults().value(forKey: "City") as? String
        }
        set {
            UserDefaults().setValue(newValue, forKey: "City")
        }
    }
}
