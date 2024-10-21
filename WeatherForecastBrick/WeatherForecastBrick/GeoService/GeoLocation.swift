import Foundation


// MARK: - CityData
struct CityData: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case lat
        case lon
    }
}
