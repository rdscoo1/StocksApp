import Foundation

extension String {

    /// Returns a localized string pulled from `Localizable.strings` by its key.
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
