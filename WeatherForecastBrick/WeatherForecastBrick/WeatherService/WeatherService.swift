import Foundation

// MARK: - WeatherService

class WeatherService {
    
    // MARK: - Fetch Data
    
    func fetchWeatherData(lat: Double, lon: Double, apiKey: String) async throws -> WeatherData {
        // Forming the URL
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)&units=metric"
        
        // Validating the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        // Fetching data from the API
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            // Decoding the JSON response
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            return weatherData
        } catch {
            // Handling decoding errors
            throw error
        }
    }
}




//completion handler // основна відмінність більший контроль результатів та підтримка всфх версій IOS
class WeatherServiceCompletion {
    func fetchWeatherData(lat: Double, lon: Double, apiKey: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let weaterData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weaterData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
