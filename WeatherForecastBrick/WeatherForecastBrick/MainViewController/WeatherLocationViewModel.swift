import Foundation
import Combine

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    
    // MARK: - Services
    private let weatherService = WeatherService()
    private let geoService = GeoService()
    
    // MARK: - Data Properties
    @Published private(set) var cities = [CityData]()
    @Published private(set) var selectedCityName: String
    @Published private(set) var selectedCountryName: String
    
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var id: UUID
    
    private var fetchTask: Task<Void, Never>?
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(
        selectedCityName: String = "",
        selectedCountryName: String = "",
        latitude: Double = 0,
        longitude: Double = 0,
        id: UUID? = nil
    ) {
        self.selectedCityName = selectedCityName
        self.selectedCountryName = selectedCountryName
        self.latitude = latitude
        self.longitude = longitude
        self.id = id ?? UUID()
        super.init()
        setupDebounceForSearchInput()
    }
    
    func updateLocation(latitude: Double, longitude: Double) async {
        self.latitude = latitude
        self.longitude = longitude
        
        Task {
            let city = try await fetchCityByLocation(lon: longitude, lat: latitude)
            let fullCountryName = city.getFullCountryName()
            self.selectedCityName = city.name
            self.selectedCountryName = fullCountryName
        }
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
        let currentWeather = try await weatherService.fetchWeatherData(
            lat: latitude,
            lon: longitude,
            apiKey: getAPIKey()
        )
        return currentWeather
    }
    
    // MARK: - Fetch City By Location
    func fetchCityByLocation(lon: Double, lat: Double) async throws -> CityLocation {
        let city = try await geoService.fetchCityByCoordinates(
            lon: lon,
            lat: lat,
            apiKey: getAPIKey()
        )
        return city
    }
    
    // MARK: - Fetch City
    func fetchCity(_ text: String) async throws -> [CityData] {
        let city = try await geoService.fetchCities(
            for: text,
            apiKey: getAPIKey()
        )
        return city
    }
    
    func updateCities(with newCities: [CityData]) {
        cities = newCities
    }

    // MARK: - Fetch Cities Based on Query
    private func fetchCities(for searchQuery: String) async throws {
        fetchTask?.cancel()
        
        guard !searchQuery.isEmpty else {
            self.cities = []
            return
        }
        
        fetchTask = Task {
            do {
                let fetchedCities = try await geoService.fetchCities(
                    for: searchQuery,
                    apiKey: getAPIKey()
                )
                DispatchQueue.main.async {
                    self.cities = fetchedCities
                }
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
                    do {
                        try await self?.fetchCities(for: searchText)
                    }
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
