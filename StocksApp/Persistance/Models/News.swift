import Foundation

struct News: Decodable {
    let datetime: Int
    let headline: String
    let source: String
    let url: String
    let summary: String
    let related: String
    let image: String
    let lang: String
    let hasPaywall: Bool
}
