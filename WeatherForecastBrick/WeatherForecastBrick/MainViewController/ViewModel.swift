import Foundation

// MARK: - ViewModel
class ViewModel: NSObject {
    let weatherService = WeatherService()
    let geoService = GeoService()
    
    let apiKey = "797954b9be1e6cfc8ec1a67b9459cbcb"
    
    var selectedCityName: String
    var selectedContryName: String
    var latitude: Double
    var longitude: Double
    
    init(selectedCityName: String = "Ivano-Frankivsk", selectedContryName: String = "Ukraine", latitude: Double = 51.5074, longitude: Double = -0.1278) {
        self.selectedCityName = selectedCityName
        self.selectedContryName = selectedContryName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getWeather() async throws -> WeatherData {
        do {
            let currentWeather = try await weatherService.fetchWeatherData(
                lat: latitude,
                lon: longitude,
                apiKey: apiKey
            )
            print("Weather data: \(currentWeather)")
            return currentWeather
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchCities(for query: String) async throws -> [CityData] {
        do {
            let cities = try await geoService.fetchCities(for: query, apiKey: apiKey)
            print("Cities fetched: \(cities)")
            return cities
        } catch {
            print("Error fetching cities: \(error.localizedDescription)")
            throw error
        }
    }
}
