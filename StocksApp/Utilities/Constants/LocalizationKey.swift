import Foundation

extension Constants {
    enum LocalizationKey: String {

        // Titles
        case stocks = "Stocks"

        // Stock Details
        case chart = "Chart"
        case summary = "Summary"
        case news = "News"

        // Settings
        case settings = "Settings"

        // Appearance
        case appearance = "Appearance"
        case adaptive = "Adaptive"
        case light = "Light"
        case dark = "Dark"

        // Support
        case leaveRating = "Leave a rating"
        case supportFreeProject = "Support the developer's free side project!"
        case shareApp = "Share the app"
        case shareWithFriends = "Share this app with your friends!"
        case sendFeedback = "Send feedback"
        case bugsToEmail = "Email thoughts, bugs, or questions."

        case developedBy = "Developed by"
        case version = "Version"

        var string: String {
            return rawValue.localized
        }
    }
}
