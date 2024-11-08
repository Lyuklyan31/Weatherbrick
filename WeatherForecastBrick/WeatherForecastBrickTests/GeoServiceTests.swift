import XCTest
import CoreLocation
@testable import WeatherForecastBrick

final class GeoServiceTests: XCTestCase {
    static var geoService: GeoService!
    
    private let kyivCoordinate = CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234)
    private let londonCoordinate = CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278)
        
    override class func setUp() {
        super.setUp()
        geoService = GeoService()
    }
    
    override class func tearDown() {
        geoService = nil
        super.tearDown()
    }
    
    func testFetchCitiesReturnsValidData() async {
        let query = "Kyiv"
        
        do {
            let cities = try await GeoServiceTests.geoService.fetchCitiesByName(for: query)
            
            XCTAssertGreaterThan(cities.count, 0, "Expected to fetch at least one city.")
            XCTAssertEqual(cities.first?.name, "Kyiv", "Expected the first city to be Kyiv.")
            XCTAssertEqual(cities.first?.country, "UA", "Expected the first country to be UA.")
        } catch {
            XCTFail("Expected to fetch cities but got error: \(error)")
        }
    }
    
    func testFetchCitiesReturnsEmptyArray() async {
        let query = "nonexistent city"
        
        do {
            let cities = try await GeoServiceTests.geoService.fetchCitiesByName(for: query)
            XCTAssertTrue(cities.isEmpty, "Expected an empty array when the city does not exist.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFetchByCoordinatesKyiv() async {
        do {
            let city = try await GeoServiceTests.geoService.fetchCityByCoordinates(
                longitude: kyivCoordinate.longitude, latitude: kyivCoordinate.latitude
            )
            
            XCTAssertEqual(city.name, "Kyiv", "Expected the city to be Kyiv.")
            XCTAssertEqual(city.country, "UA", "Expected the city to be Kyiv.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFetchByCoordinatesLondon() async {
        do {
            let city = try await GeoServiceTests.geoService.fetchCityByCoordinates(
                longitude: londonCoordinate.longitude, latitude: londonCoordinate.latitude
            )
            
            XCTAssertEqual(city.name, "London", "Expected the city to be London.")
            XCTAssertEqual(city.country, "GB", "Expected the city to be UK.")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}
