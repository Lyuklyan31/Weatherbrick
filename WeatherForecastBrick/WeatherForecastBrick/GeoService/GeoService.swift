import Foundation

// MARK: - GeoService
class GeoService {
  
    func fetchCities(for query: String, apiKey: String) async throws -> [CityData] {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedQuery)&limit=10&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
         
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
         
            let decodedResponse = try JSONDecoder().decode([CityData].self, from: data)
            return decodedResponse
            
        } catch {
            throw error
        }
    }
}
