import Foundation
import Combine

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    
    // MARK: - Services
    private let weatherService = WeatherService()
    private let geoService = GeoService()
    
    // MARK: - Data Properties
    @Published var cities = [CityData]()
    var selectedCityName: String
    var selectedCountryName: String
    var latitude: Double
    var longitude: Double
    
    private var fetchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initializer
    init(
        selectedCityName: String = "Ivano-Frankivsk",
        selectedCountryName: String = "Ukraine",
        latitude: Double = 48.9224763,
        longitude: Double = 48.710334
    ) {
        self.selectedCityName = selectedCityName
        self.selectedCountryName = selectedCountryName
        self.latitude = latitude
        self.longitude = longitude
        super.init()
        setupDebounceForSearchInput()
    }
    
    // MARK: - Update Selected City
    func updateSelectedCity(at index: Int) {
        guard index >= 0 && index < cities.count else { return }
        let selected = cities[index]
        
        selectedCityName = selected.name
        selectedCountryName = selected.getFullCountryName()
        latitude = selected.lat
        longitude = selected.lon
    }
    
    // MARK: - Get Weather Data
    func getWeather() async throws -> WeatherData {
        do {
            let currentWeather = try await weatherService.fetchWeatherData(
                lat: latitude,
                lon: longitude,
                apiKey: getAPIKey()
            )
            return currentWeather
        } catch {
            throw error
        }
    }

    // MARK: - Fetch City
    func fetchCity(query : String) async throws -> [CityData] {
        let city = try await geoService.fetchCities(
            for: query,
            apiKey: getAPIKey()
        )
        return city
    }

    // MARK: - Fetch Cities Based on Query
    private func fetchCities(for searchQuery: String) async throws {
        fetchTask?.cancel()
        
        fetchTask = Task {
            do {
                let fetchedCities = try await geoService.fetchCities(
                    for: searchQuery,
                    apiKey: getAPIKey()
                )
                self.cities = fetchedCities
            } catch {
            }
        }
    }

    // MARK: - Debounce Setup
    private func setupDebounceForSearchInput() {
        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                Task {
                    try await self?.fetchCities(for: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Update Search Text
    func getTextFromTextField(_ text: String) {
        searchTextSubject.send(text)
    }
    
    // MARK: - Get API Key
    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
