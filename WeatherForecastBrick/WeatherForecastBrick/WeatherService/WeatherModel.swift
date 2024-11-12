import Foundation
import UIKit

// MARK: - WeatherData
struct WeatherData: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
}

// MARK: - MainWeather
struct MainWeather: Codable {
    let temp: Double
}

// MARK: - WeatherCondition
struct WeatherCondition: Codable {
    let main: WeatherTypes 
}

