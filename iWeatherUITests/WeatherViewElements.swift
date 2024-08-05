//
//  WeatherViewElements.swift
//  iWeatherUITests
//
//  Created by Karthika on 03/08/2024. 

import XCTest

class WeatherViewElements: XCTest {
    let app = XCUIApplication()
 
    var getCellElement: XCUIElement {
        return app.cells.element(matching: .cell, identifier: "WeatherCell:Cell")
    }
    
    var searchBarElement: XCUIElement {
        return app.otherElements["WeatherCell:SearchBar"]
    }
    
    var cityNameElement: XCUIElement {
        return app.staticTexts.element(matching: .any, identifier: "WeatherCell:Location")
    }
    
    var weatherElement: XCUIElement {
        return app.staticTexts.element(matching: .any, identifier: "WeatherCell:Weather")
    }
    
    var temperatureElement: XCUIElement {
        return app.staticTexts.element(matching: .any, identifier: "WeatherCell:Degrees")
    }
    
    var minMaxElement: XCUIElement {
        return app.staticTexts.element(matching: .any, identifier: "WeatherCell:MinMax")
    }
    
    var IconElement: XCUIElement {
        return app.images.element(matching: .image, identifier: "WeatherCell:Icon")
    }
    
    var citytableElement: XCUIElement {
        return app.tables.element(matching: .table, identifier: "CityTable:Table")
    }

    var doneButton: XCUIElement {
        return app.buttons["CityTable:DoneButton"]
    }
    
}
