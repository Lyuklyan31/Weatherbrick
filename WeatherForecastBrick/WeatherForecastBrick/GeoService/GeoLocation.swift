import Foundation

// MARK: - CityData
struct CityData: Decodable, Hashable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}
