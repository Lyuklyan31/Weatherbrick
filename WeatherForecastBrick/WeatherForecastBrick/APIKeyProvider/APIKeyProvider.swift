import Foundation

// MARK: - APIKeyProvider
struct APIKeyProvider {
    static func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String ?? ""
    }
}
