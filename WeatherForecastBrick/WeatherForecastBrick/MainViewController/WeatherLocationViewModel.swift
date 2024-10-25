import Foundation

// MARK: - WeatherLocationViewModel
class WeatherLocationViewModel: NSObject {
    
    // MARK: - Services
    let weatherService = WeatherService()
    let geoService = GeoService()
    
    // MARK: - Data Properties
    var cities = [CityData]()
    var selectedCityName: String
    var selectedCountryName: String
    var latitude: Double
    var longitude: Double
    
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
            print("Error fetching weather: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Fetch Cities
    func fetchCities(for query: String) async throws -> [CityData] {
        do {
            let cities = try await geoService.fetchCities(
                for: query,
                apiKey: getAPIKey()
            )
            return cities
        } catch {
            print("Error fetching cities: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Get API Key
    private func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
