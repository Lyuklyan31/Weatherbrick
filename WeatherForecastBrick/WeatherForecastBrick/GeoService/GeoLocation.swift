import Foundation

// MARK: - CityData
struct CityData: Decodable, Hashable {
    var id: UUID? = UUID()
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    private enum CodingKeys: CodingKey {
        case id
        case name
        case country
        case lat
        case lon
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CityData.CodingKeys> = try decoder.container(keyedBy: CityData.CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: CityData.CodingKeys.name)
        self.country = try container.decode(String.self, forKey: CityData.CodingKeys.country)
        self.lat = try container.decode(Double.self, forKey: CityData.CodingKeys.lat)
        self.lon = try container.decode(Double.self, forKey: CityData.CodingKeys.lon)
    }
}
