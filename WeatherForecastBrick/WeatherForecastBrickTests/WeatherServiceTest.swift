import XCTest
@testable import WeatherForecastBrick

final class WeatherServiceTest: XCTestCase {
    var weatherService: WeatherService!

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }

    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }
    
    func testFetchWeatherLondon() async {
        let longitude = 0.1278
        let latitude = 51.5074
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(lat: latitude, lon: longitude)
            
            XCTAssertGreaterThan(weatherData.main.temp, -100, "Expected a reasonable temperature value.")
            XCTAssertLessThan(weatherData.main.temp.kelvinToCelsius(), 60, "Expected a reasonable temperature value.")
            XCTAssertGreaterThan(weatherData.weather.count, 0, "Expected at least one weather condition in the response.")
        } catch {
            XCTFail("Expected to fetch cities but got error: \(error)")
        }
    }
    
    func testFetchWeatherKyiv() async {
        let longitude = 30.5234
        let latitude = 50.4501
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(lat: latitude, lon: longitude)
            
            XCTAssertGreaterThan(weatherData.main.temp, -100, "Expected a reasonable temperature value.")
            XCTAssertLessThan(weatherData.main.temp.kelvinToCelsius(), 60, "Expected a reasonable temperature value.")
            XCTAssertGreaterThan(weatherData.weather.count, 0, "Expected at least one weather condition in the response.")
        } catch {
            XCTFail("Expected to fetch cities but got error: \(error)")
        }
    }
    
    // MARK: - Helpers
    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
