import Foundation

struct Stock: Decodable {
    var symbol: String
    let companyName: String
    var latestPrice: Double
    var change: Double
}
