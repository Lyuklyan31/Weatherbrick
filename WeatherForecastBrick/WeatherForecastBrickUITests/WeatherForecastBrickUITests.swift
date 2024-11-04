import XCTest

// WeatherAppUITests
class WeatherAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
    }
    
    // MARK: - TestTemperatureLabel
    func testTemperatureLabelExists() {
        let temperatureLabel = app.staticTexts["temperatureLabelIdentifier"]
        XCTAssertTrue(temperatureLabel.exists, "Temperature label should exist on the main screen for the city: Kyiv")
        let temperatureText = temperatureLabel.label
        let isInteger = NSPredicate(format: "SELF MATCHES %@", "^[0-9]+$").evaluate(with: temperatureText)
        XCTAssertTrue(isInteger, "Temperature label does not contain an integer value")
    }
    
    // MARK: - TestWeatherConditionLabel
    func testWeatherConditionLabelDisplaysCorrectValue() {
        let weatherConditionLabel = app.staticTexts["weatherConditionLabelIdentifier"]
        XCTAssertTrue(weatherConditionLabel.exists, "Weather condition label does not exist")
        
        let validWeatherConditions = ["Clear", "Clouds", "Rain", "Snow", "Thunderstorm", "Drizzle", "Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado"]
        let labelValue = weatherConditionLabel.label
        sleep(2)
        XCTAssertTrue(validWeatherConditions.contains(labelValue), "Weather condition label does not contain a valid value")
    }
    
    // MARK: - TestBrickUIImageView
    func testBrickUIImageViewPositionAfterSwipe() {
        let brickUIImageView = app.images["brickUIImageIdentifier"]
        XCTAssertTrue(brickUIImageView.waitForExistence(timeout: 0), "brickUIImageView does not exist")
        
        let initialY = brickUIImageView.frame.origin.y
        brickUIImageView.swipeDown()
        sleep(1)
        
        XCTAssertEqual(brickUIImageView.frame.origin.y, initialY, "brickUIImageView did not return to its initial Y position")
    }
    
    // MARK: - TestLocationButton
    func testWeatherTypeLabelExists() {
        let weatherTypeLabel = app.staticTexts["weatherConditionLabelIdentifier"]
        XCTAssertTrue(weatherTypeLabel.exists, "Weather type label should exist on the main screen for the city: Kyiv")
    }
    
    // MARK: - TestLocationButton
    func testTapLocationButton() {
        let locationButton = app.buttons["locationButtonIdentifier"]
        XCTAssertTrue(locationButton.exists, "Location button should exist on the main screen for the city: Kyiv")
        
        locationButton.tap()
        
        let searchTextField = app.textFields["Enter city name"]
        XCTAssertTrue(searchTextField.exists, "Search text field should be visible after tapping the location button for the city: Kyiv")
    }
    
    // MARK: - TestSearchForCity
    func testSearchForCity() {
        let locationButton = app.buttons["locationButtonIdentifier"]
        XCTAssertTrue(locationButton.exists, "Location button should exist on the main screen for the city: Kyiv")
        
        locationButton.tap()
        
        let searchTextField = app.textFields["Enter city name"]
        searchTextField.tap()
        searchTextField.buttons["Clear text"].tap()
        searchTextField.typeText("Kyiv")
        
        sleep(1)

        let firstCell = app.cells.staticTexts["Kyiv, Ukraine"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3), "City 'Kyiv' should be shown in the results for the search.")

        let firstCityCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCityCell.exists, "The first city cell should exist.")
        
        firstCityCell.tap()
        sleep(1)

        let locationButtonUpdated = app.buttons["locationButtonIdentifier"]
        XCTAssertTrue(locationButtonUpdated.exists, "Location button should still exist after selecting a city.")
        
        let locationButtonTitle = locationButtonUpdated.label
        XCTAssertEqual(locationButtonTitle, "Kyiv, Ukraine", "The location button title should update to the selected city.")
    }
    
    // MARK: - TestSelectCity
    func testSelectCity() {
        let locationButton = app.buttons["locationButtonIdentifier"]
        locationButton.tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        firstCell.tap()
        
        let locationButtonUpdated = app.buttons["locationButtonIdentifier"]
        XCTAssertTrue(locationButtonUpdated.exists, "Location button should still exist after selecting a city: Kyiv")
        
        let locationButtonTitle = locationButtonUpdated.label
        XCTAssertFalse(locationButtonTitle.isEmpty, "Location button title should update with selected city: Kyiv")
    }
}
