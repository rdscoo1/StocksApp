import Foundation

extension Constants {
    enum LocalizationKey: String {

        // Titles
        case stocks = "Stocks"

        var string: String {
            return rawValue.localized
        }
    }
}
