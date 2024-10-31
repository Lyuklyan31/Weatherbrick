import XCTest
@testable import WeatherForecastBrick

final class GeoServiceTests: XCTestCase {
    var geoService: GeoService!

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        geoService = GeoService()
    }

    override func tearDown() {
        geoService = nil
        super.tearDown()
    }
    
// MARK: - Fetch City Tests

    func testFetchCitiesReturnsValidData() async {
        let query = "Kyiv"
        
        do {
            let cities = try await geoService.fetchCitiesByName(for: query)
            
            XCTAssertGreaterThan(cities.count, 0, "Expected to fetch at least one city.")
            XCTAssertEqual(cities.first?.name, "Kyiv", "Expected the first city to be Kyiv.")
            XCTAssertEqual(cities.first?.country, "UA", "Expected the first country to be UA.")
        } catch {
            XCTFail("Expected to fetch cities but got error: \(error)")
        }
    }
    
    func testFetchCitiesReturnsEmptyArray() async {
        let geoService = GeoService()
        
        do {
            let cities = try await geoService.fetchCitiesByName(for: "nonexistent city")
            XCTAssertTrue(cities.isEmpty, "Expected an empty array when the city does not exist.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
// MARK: Fetch City By Coordinate
    
    func testFetchByCoordinatesKyiv() async {
        let longitude = 30.5234
        let latitude = 50.4501
        
        do {
            let city = try await geoService.fetchCityByCoordinates(longitude: longitude, latitude: latitude)
            
            XCTAssertEqual(city.name, "Kyiv", "Expected the city to be Kyiv.")
            XCTAssertEqual(city.country, "UA", "Expected the city to be Kyiv.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFetchByCoordinatesLondon() async {
        let longitude = 0.1278
        let latitude = 51.5074
        
        do {
            let city = try await geoService.fetchCityByCoordinates(longitude: longitude, latitude: latitude)
            
            XCTAssertEqual(city.name, "London", "Expected the city to be London.")
            XCTAssertEqual(city.country, "GB", "Expected the city to be UK.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    // MARK: - Helpers

    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
