import Foundation

struct Stock: Decodable {
    var symbol: String
    let companyName: String
    var latestPrice: Double
    var change: Double

    var companyLogoUrl: String {
        return "https://storage.googleapis.com/iex/api/logos/\(symbol).png"
    }
}
