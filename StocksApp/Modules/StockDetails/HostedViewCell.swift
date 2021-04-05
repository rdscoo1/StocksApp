import UIKit

class HostedViewCell: UICollectionViewCell {

    static let reuseIdentifier = "HostedViewCell"

    // MARK: - HostedView

    private weak var _hostedView: UIView? {
        didSet {
            if let oldValue = oldValue {
                if oldValue.isDescendant(of: self) { // Make sure that hostedView hasn't been added as a subview to a different cell
                    oldValue.removeFromSuperview()
                }
            }

            if let _hostedView = _hostedView {
                _hostedView.frame = contentView.bounds
                contentView.addSubview(_hostedView)
            }
        }
    }

    weak var hostedView: UIView? {
        get {
            guard _hostedView?.isDescendant(of: self) ?? false else {
                _hostedView = nil
                return nil
            }

            return _hostedView
        }
        set {
            _hostedView = newValue
        }
    }
    
    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        hostedView = nil
    }
}
