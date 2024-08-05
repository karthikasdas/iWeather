//
//  iWeatherUITests.swift
//  iWeatherUITests
//
//  Created by Karthika on 8/1/24.
//

import XCTest

final class iWeatherUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func checkingForElements(elementsView: WeatherViewElements) {
        XCTAssert(elementsView.getCellElement.exists)
        XCTAssert(elementsView.weatherElement.exists)
        XCTAssert(elementsView.minMaxElement.exists)
        XCTAssert(elementsView.temperatureElement.exists)
        XCTAssert(elementsView.IconElement.exists)
        XCTAssert(elementsView.cityNameElement.exists)
        XCTAssert(elementsView.searchBarElement.exists)
        XCTAssert(elementsView.doneButton.exists)
    }
    
    func searchForCity(elementsView: WeatherViewElements) {
        elementsView.searchBarElement.doubleTap()
        elementsView.searchBarElement.typeText("New York")
    }
    
    func testWeatherView() {
                let elementsView = WeatherViewElements()
        checkingForElements(elementsView: elementsView)
    }
    
    func testCitiesView() {
        let elementsView = WeatherViewElements()
        searchForCity(elementsView: elementsView)
        XCTAssert(elementsView.citytableElement.exists)
    }
    
    func testUpdateWeatherView() {
        let elementsView = WeatherViewElements()
        searchForCity(elementsView: elementsView)
        elementsView.doneButton.tap()
        checkingForElements(elementsView: elementsView)
    }
    
}
