import Foundation
import Combine
import Network

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    
    // MARK: - Location Data
    struct City: Identifiable, Hashable {
        var cityName = ""
        var countryName = ""
        var latitude = 0.0
        var longitude = 0.0
        var id = UUID()
    }
    
    // MARK: - Services
    private let weatherService = WeatherService()
    private let geoService = GeoService()
    
    // MARK: - Data Properties
    @Published private(set) var cities = [City]()
    @Published private(set) var city = City()
    
    // MARK: - Weather Data
    @Published private(set) var weatherData: WeatherData?
    
    // MARK: - Network Monitor
    private let monitor = NWPathMonitor()
    private(set) var isNetworkAvailable: Bool = false
    
    // MARK: - Initializer
   override init() {
        super.init()
        setupNetworkMonitor()
    }
    
    // MARK: - Fetch City by Coordinate
    func fetchCityByCoordinate(latitude: Double, longitude: Double) async {
        do {
            let fetchedCity = try await geoService.fetchCityByCoordinates(longitude: longitude, latitude: latitude)
            city = City(
                cityName: fetchedCity.name,
                countryName: fetchedCity.fullCountryName,
                latitude: fetchedCity.lat,
                longitude: fetchedCity.lon,
                id: self.city.id
            )
        } catch {
            self.cities = []
        }
    }
    
    // MARK: - Update Selected City
    func updateSelectedCity(at index: Int) {
        let selected = cities[index]
        city = selected
    }
    
    // MARK: - Get Weather Data
    func getWeather() async  {
        do {
            self.weatherData = try await weatherService.fetchWeatherData(lat: city.latitude, lon: city.longitude)
        } catch {
            self.weatherData = nil
        }
    }
    
    // MARK: - Fetch Cities Based on Query
    func fetchCities(for searchQuery: String) async {
        do {
            let fetchedCities = try await geoService.fetchCitiesByName(for: searchQuery)
            self.cities = fetchedCities.map { city in
                City(
                    cityName: city.name,
                    countryName: city.fullCountryName,
                    latitude: city.lat,
                    longitude: city.lon,
                    id: self.city.id
                )
            }
        } catch {
            self.cities = []
        }
    }
    
    // MARK: - Network Monitor
    func setupNetworkMonitor() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = (path.status == .satisfied)
        }
    }
}
