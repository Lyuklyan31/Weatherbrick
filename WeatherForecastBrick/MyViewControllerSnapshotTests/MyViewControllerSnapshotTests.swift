import XCTest
import SnapshotTesting
@testable import WeatherForecastBrick

// MARK: - MainViewControllerSnapshotTests
class MainViewControllerSnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - TestMainViewControllerAppearance
    func testMainViewControllerAppearance() {
        let expectation = self.expectation(description: "Waiting for UI to load")
        
        let mainViewController = MainViewController()
        let viewModel = WeatherLocationViewModel()
        mainViewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        
        viewModel.configureForTesting(
            city: WeatherLocationViewModel.City(cityName: "Kyiv", countryName: "Ukraine", latitude: 50.45, longitude: 30.523, id: UUID()),
            weatherData: WeatherData(main: MainWeather(temp: 293.15), weather: [WeatherCondition(main: .clear)]),
            isNetworkAvailable: true
        )
        
        mainViewController.viewModel = viewModel
        mainViewController.loadViewIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
        
        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(of: mainViewController, as: .image(on: .iPhoneX))
        }
    }
}
