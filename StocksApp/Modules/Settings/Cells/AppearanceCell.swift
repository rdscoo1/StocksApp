import UIKit

class AppearanceCell: UITableViewCell {

    static let reuseId = String(describing: self)

    // MARK: - UI

    private lazy var appearanceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Constants.LocalizationKey.adaptive.string,
                                                          Constants.LocalizationKey.light.string,
                                                          Constants.LocalizationKey.dark.string])
        segmentedControl.addTarget(self, action: #selector(appearanceValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    // MARK: - Public Property

    var appearanceSelectedCallback: (() -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let appearanceSelection = UserDefaults.standard.integer(forKey: "appearanceSelection")
        appearanceSegmentedControl.selectedSegmentIndex = appearanceSelection
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupLayout() {
        contentView.addSubview(appearanceSegmentedControl)
        appearanceSegmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
    }

    @objc private func appearanceValueChanged(_ sender: Any) {
        let defaults = UserDefaults.standard

        if appearanceSegmentedControl.selectedSegmentIndex == 0 {
            defaults.setValue(0, forKey: "appearanceSelection")
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSegmentedControl.selectedSegmentIndex == 1 {
            defaults.setValue(1, forKey: "appearanceSelection")
            overrideUserInterfaceStyle = .light
        } else if appearanceSegmentedControl.selectedSegmentIndex == 2 {
            defaults.setValue(2, forKey: "appearanceSelection")
            overrideUserInterfaceStyle = .dark
        } else {
            print("selection error")
        }
        
        appearanceSelectedCallback?()
    }
}
