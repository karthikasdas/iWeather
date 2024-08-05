//
//  LocationManager.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    var stopLocation = true
    static var cityName: String?
    let locationManager: CLLocationManager
    var handler: ((String?, WError?) -> ()?)? = nil
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentUserLocation(completion: @escaping (String?,WError?) -> ()) {
        check(status: locationManager.authorizationStatus)
        handler = completion
    }
    
    private func stopLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let recentLocation = locations.last, stopLocation == true else {
            return
        }
        stopLocation = false
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(recentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else {
                DispatchQueue.main.async {
                    self.callError()
                }
                return
            }
            if let city = placemark.locality {
                DispatchQueue.main.async {
                    LocationManager.cityName = city
                    self.handler?(city,nil)
                    self.stopLocationManager()
                }
            } else if let _ = error  {
                DispatchQueue.main.async {
                    self.callError()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopLocationManager()
        DispatchQueue.main.async {
            self.callError()
        }
    }
}

extension LocationManager {
    private func callError() {
        self.handler?(nil,WError.NetworkError)
        self.stopLocationManager()
    }
    
    private func check(status: CLAuthorizationStatus?) {
        guard let status = status else { return }
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.callError()
            }
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            DispatchQueue.main.async {
                self.callError()
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        check(status: manager.authorizationStatus)
    }
}
