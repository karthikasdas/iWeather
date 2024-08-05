//
//  WeatherViewController.swift
//  iWeather
//
//  Created by Karthika on 8/1/24.
//

import UIKit
import CoreLocation

protocol SearchCitySelected: AnyObject {
    func citySelected(of name:String)
}

class WeatherViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var launchImage: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var weatherVM: WeatherViewModelProtocol!
    
    private var dataSource: WeatherTableViewDataSource<WeatherCell,WeatherData>!
    var searchVC:SearchCityViewController?
    
    
    required init?(coder: NSCoder) {
        self.weatherVM = WeatherViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        setUpSearchBar()
    }
    
    func initializeData() {
        hideUnhideActivityIndidator(hide:false)
        self.weatherTableView.register(UINib(nibName: WeatherConstants.Names.weatherCell, bundle: nil), forCellReuseIdentifier: WeatherConstants.Names.weatherCell)
        self.title = WeatherConstants.Names.weather
        self.doneButton.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.doneButton
        callViewModelForData()
    }
    
    func callViewModelForData(){
        guard let city = SaveCityName.storedCityName else {
            LocationManager.shared.getCurrentUserLocation { city, error in
                self.callVM(with: city)
            }
            return
        }
        callVM(with: city)
    }
    
    func hideUnhideActivityIndidator(hide:Bool) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = hide
            if hide {
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func setUpSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search for the city "
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        self.searchBar.accessibilityIdentifier = WeatherConstants.IdentifiersForTest.searchBar
    }
    
    func callVM(with city: String?) {
        guard let city = city else {
            hideUnhideActivityIndidator(hide:true)
            showError(WeatherConstants.ErrorMessages.locError)
            return
        }
        self.weatherVM.callFuncToGetWeatherData(with: city)
        self.weatherVM.bindWeatherViewModelToController = { weather,_ in
            guard let weather = weather else {
                DispatchQueue.main.async {
                    SaveCityName.storedCityName = city
                    self.hideUnhideActivityIndidator(hide:true)
                    self.showError(WeatherConstants.ErrorMessages.generalError)
                }
                return
            }
            self.updateDataSource(weatherData: weather)
        }
    }
    
    func showError(_ msg: String) {
        let alert = UIAlertController(title: WeatherConstants.ErrorMessages.generalErrorHeader,
                                      message: msg,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.destructive)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func updateDataSource(weatherData: WeatherData) {
        self.dataSource = WeatherTableViewDataSource(cellIdentifier: WeatherConstants.Names.weatherCell, list: [weatherData], configureCell: { cell, data in
            cell.weatherData = data
            DispatchQueue.global().async {
                let image = self.weatherVM.loadIcon(with: data.icon)
                DispatchQueue.main.async {
                    cell.icon.image = image
                }
            }
        })
        DispatchQueue.main.async {
            self.hideUnhideActivityIndidator(hide:true)
            self.weatherTableView.dataSource = self.dataSource
            self.weatherTableView.reloadData()
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.searchVC?.view.isHidden = true
        guard let text = searchBar.text, isTextValid(text: text) else {
            hideUnhideActivityIndidator(hide:true)
            showError(WeatherConstants.ErrorMessages.cityError)
            return
        }
        self.callVM(with: text)
    }
    
    func isTextValid(text: String) -> Bool {
        guard text.isEmpty == false else {
            return false
        }
        do {
            let regex = try NSRegularExpression(pattern: WeatherConstants.Regex.regex, options: .caseInsensitive)
            if let _ = regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) {
                return false
            } else {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let _ = searchBar.text, searchVC == nil else {
            return }
        
        DispatchQueue.main.async {
            self.hideUnhideActivityIndidator(hide: false)
            self.createSearchView()
        }
    }
    
    func createSearchView() {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityViewController") as? SearchCityViewController {
            self.searchVC = controller
            self.searchBar.delegate = self.searchVC
            self.addChild(self.searchVC!)
            self.searchVC!.view.frame = CGRect(x: 20, y: 160, width: self.view.frame.size.width - 40, height: 300)
            self.searchVC?.view.layer.cornerRadius = 10.0
            self.view.addSubview(self.searchVC!.view)
            self.view.bringSubviewToFront(self.searchVC!.view)
            self.searchVC!.didMove(toParent: self)
            self.searchVC!.selectedCityFromSearchView = { city in
                if let city = city {
                    self.searchBar.text = city
                    self.callVM(with: city)
                    self.hideUnhideActivityIndidator(hide:false)
                } else {
                    self.hideUnhideActivityIndidator(hide:true)
                }
            }
        }
    }
}
