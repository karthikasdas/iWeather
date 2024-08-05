//
//  WeatherViewModelUnitTest.swift
//  iWeatherTests
//
//  Created by Karthika on 03/08/2024. 
//

import XCTest
@testable import iWeather

class MockWeatherViewModel: WeatherViewModel {
    func getWeather(with data: WeatherService) -> WeatherData {
        return self.exposeGetWeatherData(from: data)
    }
}

final class WeatherViewModelUnitTest: XCTestCase {
    
    var mockWeatherData = WeatherService(cod: 200, weather: [Weather(icon: "")], temperature: Temperature(temp: 34.0, tempMin: 30.0, tempMax: 35.0), name: "Atlanta")
    var mockVM: MockWeatherViewModel?
    var mockService: MockService?

    override func setUpWithError() throws {
        mockVM = MockWeatherViewModel(with: "Atlanta")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetWeatherData() {
        let data = mockVM?.getWeather(with: self.mockWeatherData)
        XCTAssert(data?.cityName == mockWeatherData.name)
        XCTAssert(data?.temperature == String(mockWeatherData.temperature.temp ?? 0.0))
        XCTAssert(data?.minTemperature == String(mockWeatherData.temperature.tempMin ?? 0.0))
        XCTAssert(data?.maxTemperature == String(mockWeatherData.temperature.tempMax ?? 0.0))
        XCTAssert(data?.weather == String(mockWeatherData.weather[0].weather ?? ""))
        XCTAssert(data?.icon == String(mockWeatherData.weather[0].icon ?? ""))
    }
    
    func testLoadIconGivesNil() {
        let icon = ""
        XCTAssertNil(self.mockVM?.loadIcon(with: icon))
    }
    
    func testLoadIconGivesImage() {
        let icon = "04d"
        XCTAssertNotNil(self.mockVM?.loadIcon(with: icon))
    }
    
    func testServiceSuccess() {
        self.mockService = MockService(webService: true)
        let mockResponse: WeatherService = WeatherService(cod: 200, weather: [Weather(icon: "04d",weather: "Cloudy")], temperature: Temperature(temp: 30.0,tempMin: 28.0,tempMax: 31.0), name: "Atlanta")
        self.mockService?.apiToGetWeatherData(city: "Atlanta",success: {weather in
            if let weather = weather {
                DispatchQueue.main.async {
                    XCTAssertTrue(mockResponse.temperature.temp == weather.temperature.temp && mockResponse.name == weather.name)
                }
            }
        }, failure: {_ in})
    }
    
    func testServiceFailure() {
        self.mockService = MockService(webService: false)
        self.mockService?.apiToGetWeatherData(city: "Atlanta",success: {_ in }, failure: { error in
            DispatchQueue.main.async {
                XCTAssertTrue(error == .NetworkError)
            }
        })
    }
    
    func testGetCities() {
        self.mockService?.getCities(completion: { city in
            if let results = city.results {
                DispatchQueue.main.async {
                    XCTAssertTrue(results.count > 0)
                }
            }
        })
    }
    
}
