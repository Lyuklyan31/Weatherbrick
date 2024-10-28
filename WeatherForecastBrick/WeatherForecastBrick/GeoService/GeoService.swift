import Foundation

// MARK: - GeoService
class GeoService {
    
    // MARK: - Fetch Cities With Query
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
    
    // MARK: - Fetch City By Coordinate
    func fetchCityByCoordinates(lon: Double, lat: Double, apiKey: String) async throws -> CityLocation {
        let urlString = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedResponse = try JSONDecoder().decode([CityLocation].self, from: data)
            
            guard let city = decodedResponse.first else {
                throw NSError(domain: "No cities found", code: 404, userInfo: nil)
            }
            
            return city
            
        } catch {
            throw error
        }
    }
}
