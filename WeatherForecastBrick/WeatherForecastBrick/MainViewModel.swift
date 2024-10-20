import Foundation
import CoreLocation

class MainViewModel: NSObject {
    let weatherService = WeatherService()
    let geoService = GeoService()
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeather() async {
        guard let currentLocation = await getCurrentLocation() else {
            print("Failed to get location.")
            return
        }
        
        do {
            let weatherData = try await weatherService.fetchWeatherData(
                lat: currentLocation.latitude,
                lon: currentLocation.longitude,
                apiKey: "797954b9be1e6cfc8ec1a67b9459cbcb"
            )
            print("Weather data: \(weatherData)")
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
        }
    }

    private func getCurrentLocation() async -> (latitude: Double, longitude: Double)? {
        return await withCheckedContinuation { continuation in
            locationManager.requestLocation()
            continuation.resume(returning: nil)
        }
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Current location: \(latitude), \(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
