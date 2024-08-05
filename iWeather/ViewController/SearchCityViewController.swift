//
//  SearchCityViewController.swift
//  iWeather
//
//  Created by Karthika on 8/2/24.
//

import UIKit

protocol SearchCityUpdate: AnyObject {
    func bindVmAndUI(with cities: [CityModel])
}

class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var cityTable: UITableView!
    
    private var searchVM: SearchCityViewModel!
    
    private var dataSource: WeatherTableViewDataSource<UITableViewCell,CityModel>!
    
    private var cities:[CityModel]?
    private var filteredCities:[CityModel]?
    var selectedCityFromSearchView: ((String?) -> ())?
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        self.cityTable.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.cityTable
        self.cityTable.register(UINib(nibName: WeatherConstants.Names.cityCell, bundle: nil), forCellReuseIdentifier: WeatherConstants.Names.cityCell)
        self.cityTable.estimatedRowHeight = 60.0
        initVM()
        super.viewDidLoad()
    }
    
    func initVM() {
        self.searchVM = SearchCityViewModel(with: self)
    }
    
    func updateUI(with cities:[CityModel]) {
        self.dataSource = WeatherTableViewDataSource(cellIdentifier: WeatherConstants.Names.cityCell, list: cities, configureCell: { cell, city in
            (cell as? CityCell)?.setCityName(city: city.cityName)
        }, cellSelected: { cell, city in
            self.view.isHidden = true
            self.selectedCityFromSearchView?(city.cityName)
        })
        
        DispatchQueue.main.async {
            if cities.isEmpty == true {
                let alert = UIAlertController(title: WeatherConstants.ErrorMessages.errorHeader, message: WeatherConstants.ErrorMessages.networkError, preferredStyle: .alert)
                self.show(alert, sender: self)
            } else {
                self.cityTable.dataSource = self.dataSource
                self.cityTable.delegate = self.dataSource
                self.cityTable.reloadData()
            }
        }
    }
}

extension SearchCityViewController: SearchCityUpdate {
    func bindVmAndUI(with cities: [CityModel]) {
        self.cities = cities
        self.updateUI(with: cities)
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.view.isHidden = true
            self.selectedCityFromSearchView?(nil)
            return
        }
        self.view.isHidden = false
        self.filteredCities = self.cities?.filter({
            $0.cityName.contains(searchText)
        })
        guard let cities = self.filteredCities, cities.count > 0 else {
            return
        }
        self.updateUI(with: cities)
    }
    
}
