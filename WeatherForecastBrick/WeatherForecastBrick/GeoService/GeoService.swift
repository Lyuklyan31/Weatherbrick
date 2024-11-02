import Foundation

// MARK: - GeoService
class GeoService {
    
    // MARK: - Fetch Cities by Name
    func fetchCitiesByName(for query: String) async throws -> [CityData] {
        let apiKey = APIKeyProvider.getAPIKey()
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedQuery)&limit=10&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedResponse = try JSONDecoder().decode([CityData].self, from: data)
        return decodedResponse
    }
    
    // MARK: - Fetch Single City by Coordinates
    func fetchCityByCoordinates(longitude: Double, latitude: Double) async throws -> CityData {
        let apiKey = APIKeyProvider.getAPIKey()
        
        let urlString = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedResponse = try JSONDecoder().decode([CityData].self, from: data)
        
        guard let city = decodedResponse.first else {
            throw NSError(domain: "No cities found", code: 404, userInfo: nil)
        }
        return city
    }
}
