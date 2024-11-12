import Foundation
import CoreLocation

// MARK: - WeatherService
class WeatherService {
    
    // MARK: - Fetch Data
    
    func fetchWeatherData(coordinate: CLLocationCoordinate2D) async throws -> WeatherData {
        let apiKey = APIKeyProvider.getAPIKey()
        
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)"
     
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        
        return weatherData
    }
}
