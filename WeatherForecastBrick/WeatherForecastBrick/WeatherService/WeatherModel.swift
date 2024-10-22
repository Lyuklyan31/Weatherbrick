import Foundation

struct WeatherData: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let main: String
}
