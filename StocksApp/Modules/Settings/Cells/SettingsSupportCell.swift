import UIKit

class SettingsSupportCell: UITableViewCell {

    static let reuseId = "SettingsSupportCell"

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurableView

extension SettingsSupportCell: ConfigurableView {
    func configure(with model: Setting) {
        textLabel?.text = model.title
        detailTextLabel?.text = model.subtitle
        imageView?.image = model.image
    }
}
