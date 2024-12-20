import Foundation
import Combine
import Network
import CoreLocation

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject, ObservableObject {
    
    // MARK: - City
    struct City: Hashable, Equatable {
        var cityName = ""
        var countryName = ""
        var coordinate = CLLocationCoordinate2D()
        var id = UUID()
        var isSelected = false
        
        // MARK: Equatable
        static func == (lhs: City, rhs: City) -> Bool {
            return lhs.cityName == rhs.cityName &&
                lhs.countryName == rhs.countryName &&
                lhs.coordinate.latitude == rhs.coordinate.latitude &&
                lhs.coordinate.longitude == rhs.coordinate.longitude
        }
        
        // MARK: Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(cityName)
            hasher.combine(countryName)
            hasher.combine(coordinate.latitude)
            hasher.combine(coordinate.longitude)
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
    @Published private(set) var alertMessage: String?
    
    // MARK: - Network Monitor
    private let monitor = NWPathMonitor()
    @Published private(set) var isNetworkAvailable = false
    
    // MARK: - Initializer
    override init() {
        super.init()
        setupNetworkMonitor()
        setupLocationManager()
    }
    
    // MARK: - Update Selected City
    func updateSelectedCity(at index: Int) {
        cities.indices.forEach { cities[$0].isSelected = false }
        
        cities[index].isSelected = true
        city = cities[index]
    }
    
    // MARK: - Get Weather Data
    private func getWeather() async {
        do {
            self.weatherData = try await weatherService.fetchWeatherData(coordinate: city.coordinate)
        } catch {
            self.weatherData = nil
            alertMessage = "Error fetching weather data."
        }
    }
    
    // MARK: - Fetch Cities Based on Query
    func fetchCities(for searchQuery: String) async {
        do {
            let fetchedCities = try await geoService.fetchCitiesByName(for: searchQuery)
            var newCities = [City]()
            
            for city in fetchedCities {
                let newCity = City(
                    cityName: city.name,
                    countryName: city.fullCountryName,
                    coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
                )
                
                if !newCities.contains(newCity) {
                    newCities.append(newCity)
                }
            }
            
            self.cities = newCities
        } catch {
            self.cities = []
            alertMessage = "Error fetching cities."
        }
    }
    
    // MARK: - Fetch City by Coordinate
    private func fetchCityByCoordinate(coordinate: CLLocationCoordinate2D) async {
        do {
            let fetchedCity = try await geoService.fetchCityByCoordinates(coordinate: coordinate)
            city = City(
                cityName: fetchedCity.name,
                countryName: fetchedCity.fullCountryName,
                coordinate: CLLocationCoordinate2D(latitude: fetchedCity.lat, longitude: fetchedCity.lon)
            )
        } catch {
            self.cities = []
            alertMessage = "Error fetching city by coordinates."
        }
    }
    
    // MARK: - Network Monitor
    func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = (path.status == .satisfied)
            }
        }
        monitor.start(queue: .main)
    }
    
    // MARK: - Refresh Data
    func refreshData() {
        guard isNetworkAvailable else {
            alertMessage = "No Internet Connection"
            return
        }
        
        setupLocationManager()
        Task { await getWeather() }
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
                await fetchCityByCoordinate(coordinate: location.coordinate)
            }
        }
    }
}
