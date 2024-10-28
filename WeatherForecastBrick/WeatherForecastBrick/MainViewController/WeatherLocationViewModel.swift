import Foundation
import Combine

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    //        isSelct consistenci
    //        isnotselect
    
    // MARK: - Location Data
       struct LocationData {
           var selectedCityName: String
           var selectedCountryName: String
           var latitude: Double
           var longitude: Double
           var id: UUID
       }
    
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
    
    // MARK: - Update Current Location
    func updateLocation(latitude: Double, longitude: Double) async {
        self.latitude = latitude
        self.longitude = longitude
        // asynk task
        Task {
            let city = try await fetchCityByCoordinate(lon: longitude, lat: latitude)
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
            lon: longitude
        )
        return currentWeather
    }
    
    // MARK: - Fetch City By Location
    func fetchCityByCoordinate(lon: Double, lat: Double) async throws -> CityLocation {
        let city = try await geoService.fetchCityByCoordinates(
            lon: lon,
            lat: lat
        )
        return city
    }
    
    // MARK: - Fetch City
    func fetchCity(_ text: String) async throws -> [CityData] {
        let city = try await geoService.fetchCities(
            for: text
        )
        return city
    }
    
    // MARK: - Update Cities
    func updateCities(with newCities: [CityData]) {
        cities = newCities
    }

    // MARK: - Fetch Cities Based on Query
    private func fetchCities(for searchQuery: String) async throws {
        fetchTask?.cancel()
        
        guard !searchQuery.isEmpty else { //exeption  сервіс анкапсулюється в собі 
            self.cities = []
            return
        }
        
        fetchTask = Task {
            do {
                let fetchedCities = try await geoService.fetchCities(
                    for: searchQuery
                )
                
                self.cities = fetchedCities
                
            } catch {
               
            }
        }
    }

    // MARK: - Debounce Setup
    private func setupDebounceForSearchInput() { // observble for user
        searchTextSubject //
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in // map замість сінк
                Task {
                    do {
                        try await self?.fetchCities(for: searchText)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Update Search Text
    func getTextFromTextField(_ text: String) { // update text wiwth
        searchTextSubject.send(text)
    }
    
    // MARK: - Get API Key
    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
