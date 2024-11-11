import XCTest
import CoreLocation
@testable import WeatherForecastBrick

final class WeatherServiceTest: XCTestCase {
    var weatherService: WeatherService!
    
    private let kyivCoordinate = CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234)
    private let londonCoordinate = CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278)
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }
    
    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }
    
    func testFetchWeatherLondon() async {
        do {
            let weatherData = try await weatherService.fetchWeatherData(coordinate: kyivCoordinate)
            
            XCTAssertGreaterThan(weatherData.main.temp, -100, "Expected a reasonable temperature value.")
            XCTAssertLessThan(weatherData.main.temp.kelvinToCelsius(), 60, "Expected a reasonable temperature value.")
            XCTAssertGreaterThan(weatherData.weather.count, 0, "Expected at least one weather condition in the response.")
        } catch {
            XCTFail("Expected to fetch weather but got error: \(error)")
        }
    }
    
    func testFetchWeatherKyiv() async {
        do {
            let weatherData = try await weatherService.fetchWeatherData(coordinate: londonCoordinate)
            
            XCTAssertGreaterThan(weatherData.main.temp, -100, "Expected a reasonable temperature value.")
            XCTAssertLessThan(weatherData.main.temp.kelvinToCelsius(), 60, "Expected a reasonable temperature value.")
            XCTAssertGreaterThan(weatherData.weather.count, 0, "Expected at least one weather condition in the response.")
        } catch {
            XCTFail("Expected to fetch weather but got error: \(error)")
        }
    }
}
