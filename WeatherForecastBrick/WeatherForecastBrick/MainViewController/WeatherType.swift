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
        case .thunderstorm:
                .imageStoneWet
        case .drizzle:
                .imageStoneWet
        case .rain:
                .imageStoneWet
        case .snow:
                .imageStoneSnow
        case .clear:
                .imageStoneNormal
        case .clouds:
                .imageStoneNormal
        case .mist:
                .imageStoneNormal
        case .fog:
                .imageStoneNormal
        case .squall:
                .imageStoneNormal
        case .hot:
                .imageStoneCracks
        }
    }
}
