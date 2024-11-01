import Foundation

// MARK: - CityData
struct CityData: Decodable, Hashable {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
}
