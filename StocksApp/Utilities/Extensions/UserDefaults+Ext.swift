import UIKit

extension UserDefaults {
    var appearanceSelected: Int? {
        get { return Int(#function) }
        set { set(newValue, forKey: #function) }
    }
}
