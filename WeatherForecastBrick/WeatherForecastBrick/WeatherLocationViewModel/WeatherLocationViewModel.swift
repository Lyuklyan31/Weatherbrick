import Foundation
import Combine
import Network
import CoreLocation

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    
    // MARK: - Location Data
    struct City: Hashable, Equatable {
        var cityName = ""
        var countryName = ""
        var latitude = 0.0
        var longitude = 0.0
        var id = UUID()
        
        static func == (lhs: City, rhs: City) -> Bool {
            return lhs.cityName == rhs.cityName &&
            lhs.countryName == rhs.countryName &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
        }
    }
    
    // MARK: - Services
    private let weatherService = WeatherService()
    private let geoService = GeoService()
    
    // MARK: - Location Manager
    private let locationManager = CLLocationManager()
    
    // MARK: - Data Properties
    @Published private(set) var cities = [City]()
    
    // MARK: - City
    @Published private(set) var city = City() {
        didSet {
            Task {
                await getWeather()
            }
        }
    }
    
    // MARK: - Weather Data
    @Published private(set) var weatherData: WeatherData?
    
    // MARK: - Alert Properties
    @Published private(set) var showAlert = false
    @Published private(set) var alertMessage = ""
    
    // MARK: - Network Monitor
    private let monitor = NWPathMonitor()
    private(set) var isNetworkAvailable: Bool = false
    
    // MARK: - Initializer
    override init() {
        super.init()
        setupNetworkMonitor()
        setupLocationManager()
    }
    
    // MARK: - Update Selected City
    func updateSelectedCity(at index: Int) {
        let selected = cities[index]
        city = selected
    }
    
    // MARK: - Check if City is Selected
    func isCitySelected(_ cityData: City) -> Bool {
        return cityData == city
    }
    
    // MARK: - Get Weather Data
    private func getWeather() async {
        do {
            self.weatherData = try await weatherService.fetchWeatherData(lat: city.latitude, lon: city.longitude)
        } catch {
            self.weatherData = nil
            alertMessage = "Error fetching weather data."
            showAlert = true
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
                    id: UUID()
                )
            }
        } catch {
            self.cities = []
            alertMessage = "Error fetching cities."
            showAlert = true
        }
    }
    
    // MARK: - Fetch City by Coordinate
    private func fetchCityByCoordinate(latitude: Double, longitude: Double) async {
        do {
            let fetchedCity = try await geoService.fetchCityByCoordinates(longitude: longitude, latitude: latitude)
            city = City(
                cityName: fetchedCity.name,
                countryName: fetchedCity.fullCountryName,
                latitude: fetchedCity.lat,
                longitude: fetchedCity.lon,
                id: UUID()
            )
        } catch {
            self.cities = []
            alertMessage = "Error fetching city by coordinates."
            showAlert = true
        }
    }
    
    // MARK: - Network Monitor
    private func setupNetworkMonitor() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = (path.status == .satisfied)
        }
    }
    
    // MARK: - Location Manager Setup
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            Task {
                await fetchCityByCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
}
