//
//  WeatherViewDataSource.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import Foundation
import UIKit

class WeatherTableViewDataSource<CELL: UITableViewCell, T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
    var cellSelected : (CELL, T) -> () = {_,_ in }
    
    init(cellIdentifier : String, list : [T],configureCell: @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  list
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = self.items[indexPath.row]
        cell.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.weatherCell
        self.configureCell(cell,item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        let item = self.items[indexPath.row]
        if let city = items[indexPath.row] as? CityModel {
            city.selected = true
        }
        self.cellSelected(cell,item)
    }
}

extension WeatherTableViewDataSource where T == CityModel {
    convenience init(cellIdentifier : String, list : [T],configureCell: @escaping (CELL, T) -> (),cellSelected: @escaping (CELL, CityModel) -> ()) {
        self.init(cellIdentifier: cellIdentifier, list: list, configureCell: configureCell)
        self.cellSelected = cellSelected
    }
}
