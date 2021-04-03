import UIKit

class AppearanceCell: UITableViewCell {

    static let reuseId = String(describing: self)

    // MARK: - UI

    private lazy var appearanceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Adaptive", "Light Theme", "Dark Theme"])
        segmentedControl.addTarget(self, action: #selector(appearanceValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    // MARK: - Public Property

    var themeSelectedCallback: ((Int) -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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

    private func setAppearance() {
        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "appearanceSelection")
        appearanceSegmentedControl.selectedSegmentIndex = appearanceSelection
        themeSelectedCallback?(appearanceSelection)

        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }

    @objc private func appearanceValueChanged(_ sender: Any) {
        let defaults = UserDefaults.standard

        if appearanceSegmentedControl.selectedSegmentIndex == 0 {
            overrideUserInterfaceStyle = .unspecified
            defaults.setValue(0, forKey: "appearanceSelection")
        } else if appearanceSegmentedControl.selectedSegmentIndex == 1 {
            overrideUserInterfaceStyle = .light
            defaults.setValue(1, forKey: "appearanceSelection")
        } else if appearanceSegmentedControl.selectedSegmentIndex == 2 {
            overrideUserInterfaceStyle = .dark
            defaults.setValue(2, forKey: "appearanceSelection")
        } else {
            print("selection error")
        }
    }
}
