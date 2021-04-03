import Foundation

extension Constants {
    enum LocalizationKey: String {

        // Titles
        case stocks = "Stocks"

        // Settings
        case settings = "Settings"
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
