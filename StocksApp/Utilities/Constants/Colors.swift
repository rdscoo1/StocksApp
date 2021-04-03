import UIKit

extension Constants {
    enum Colors {
        static var appTheme: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#19191B") :
                        UIColor(hex: "#FFFFFF")
                }
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }

        static var label: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF") :
                        UIColor(hex: "#000000")
                }
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }

        // MARK: - StockCell background

        static var cellBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#19191B") :
                        UIColor(hex: "#F0F4F7")
                }
            } else {
                return UIColor(hex: "#F0F4F7")
            }
        }

        static var cellHighlightedBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#00060B") :
                        UIColor(hex: "#D1DBE3")
                }
            } else {
                return UIColor(hex: "#D1DBE3")
            }
        }

        // MARK: - Favorite button colors

        static let favoriteButtonGray = UIColor(hex: "#BABABA")

        static let isFavoriteButtonYellow = UIColor(hex: "#FFCA1C")

        // MARK: - Price change accent colors

        static let redColor = UIColor(hex: "#B22424")

        static let greenColor = UIColor(hex: "#24B25D")

        // MARK: - Settings background

        static var settingsBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#3A3A3C") :
                        UIColor(hex: "#D1D1D6")
                }
            } else {
                return UIColor(hex: "#D1D1D6")
            }
        }
    }
}
