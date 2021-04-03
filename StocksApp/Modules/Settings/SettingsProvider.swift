import Foundation

class SettingsProvider {

    // MARK: - Singleton

    static let shared = SettingsProvider()

    private init() { }

    // MARK: - Settings support rows

    func getSettingsSupport() -> [Setting] {
        return [
            .init(title: Constants.LocalizationKey.leaveRating.string,
                  subtitle: Constants.LocalizationKey.supportFreeProject.string,
                  image: .thumbsUp),
            .init(title: Constants.LocalizationKey.shareApp.string,
                  subtitle: Constants.LocalizationKey.shareWithFriends.string,
                  image: .paperplane),
            .init(title: Constants.LocalizationKey.sendFeedback.string,
                  subtitle: Constants.LocalizationKey.bugsToEmail.string,
                  image: .envelope)
        ]
    }
}
