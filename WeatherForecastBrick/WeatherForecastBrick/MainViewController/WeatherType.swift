import Foundation
import UIKit

enum WeatherType: String {
    case thunderstorm
    case drizzle
    case rain
    case snow
    case clear
    case clouds
    case mist
    case fog
    case squall
    case hot
    
    var image: UIImage {
        switch self {
        case .rain, .drizzle, .thunderstorm:
                .imageStoneWet
        case .snow:
                .imageStoneSnow
        case .clear, .clouds, .mist, .fog, .squall:
                .imageStoneNormal
        case .hot:
                .imageStoneCracks
        }
    }
}
