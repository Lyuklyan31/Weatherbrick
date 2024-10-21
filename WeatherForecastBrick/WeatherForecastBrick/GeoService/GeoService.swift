import Foundation

// MARK: - GeoService
class GeoService {
  
    func fetchCities(for query: String, apiKey: String) async throws -> [CityData] {
        
        // Check if the query string can be encoded
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Query string encoding failed")
            throw URLError(.badURL)
        }
        
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedQuery)&limit=10&appid=\(apiKey)"
        
        // Validate the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        // Perform the network request
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check the HTTP status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                throw URLError(.badServerResponse)
            }
            
            // Decode the JSON response
            let decodedResponse = try JSONDecoder().decode([CityData].self, from: data)
            return decodedResponse
            
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
            throw error
        }
    }
}
