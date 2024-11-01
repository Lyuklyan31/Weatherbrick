import Foundation
import UIKit

// MARK: - WeatherTypes
enum WeatherTypes: String, Codable {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case clear = "Clear"
    case clouds = "Clouds"
    case mist = "Mist"
    case fog = "Fog"
    case squall = "Squall"
    case hot = "Hot"
    
    // MARK: - WeatherTypeImage
    var image: UIImage {
        switch self {
        case .rain, .drizzle, .thunderstorm:
                .imageStoneWet
        case .snow:
                .imageStoneSnow
        case .clear, .clouds, .mist, .squall:
                .imageStoneNormal
        case .fog:
                .imageStoneNormal.applyBlur(radius: 5) ?? .imageStoneNormal
        case .hot:
                .imageStoneCracks
        }
    }
}

