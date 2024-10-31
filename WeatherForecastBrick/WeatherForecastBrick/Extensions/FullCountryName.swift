import Foundation

extension CityData {
    var fullCountryName: String {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: country.uppercased()) ?? ""
    }
}
