import XCTest
import SnapshotTesting
@testable import WeatherForecastBrick

class MainViewControllerSnapshotTests: XCTestCase {
    
    // MARK: - TestMainViewControllerAppearance
    func testMainViewControllerAppearance() {
        let expectation = self.expectation(description: "Waiting for UI to load")
        
        let mainViewController = MainViewController()
        let mockWrapper = MockViewModelWrapper()
        
        mainViewController.viewModel = mockWrapper.viewModel
        mainViewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        mainViewController.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
        
        assertSnapshot(of: mainViewController, as: .image(on: .iPhoneX), record: false)
    }
}

class MockViewModelWrapper {
    private let wrappedViewModel = WeatherLocationViewModel()
    
    var viewModel: WeatherLocationViewModel {
        return wrappedViewModel
    }
    
    init() {
        Task {
            await wrappedViewModel.fetchCities(for: "Kyiv")
            wrappedViewModel.updateSelectedCity(at: 0)
        }
      
        wrappedViewModel.refreshData()
    }
}
