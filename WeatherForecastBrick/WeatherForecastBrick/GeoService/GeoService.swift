import Foundation

// MARK: - GeoService
class GeoService {
    
    // MARK: - Fetch Data
    func fetchCoordinates(for location: String, apiKey: String) async throws -> GeoLocation {
        // Forming the URL
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(location)&limit=1&appid=\(apiKey)"
        
        // Validating the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        // Fetching data from the API
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            // Decoding the JSON response
            let geoLocations = try JSONDecoder().decode(GeoLocation.self, from: data)
            return geoLocations
        } catch {
            // Handling decoding errors
            throw error
        }
    }
}
