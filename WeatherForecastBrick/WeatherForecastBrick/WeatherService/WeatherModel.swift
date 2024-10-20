import Foundation


struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temp: Double
    let weather: [WeatherCondition]
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
}

