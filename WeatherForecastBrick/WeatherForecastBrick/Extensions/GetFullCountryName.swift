import Foundation

extension CityData {
    func getFullCountryName() -> String {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: country.uppercased()) ?? ""
    }
}
