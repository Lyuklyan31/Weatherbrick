import Foundation

// MARK: - MainViewModel
class MainViewModel: NSObject {
    
    let apiKey = "797954b9be1e6cfc8ec1a67b9459cbcb"
    let weatherService = WeatherService()
    let geoService = GeoService()
    
    let latitude: Double = 51.5074
    let longitude: Double = -0.1278
    
    func getWeather() async {
        do {
            let weatherData = try await weatherService.fetchWeatherData(
                lat: latitude,
                lon: longitude,
                apiKey: apiKey
            )
            print("Weather data: \(weatherData)")
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
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
