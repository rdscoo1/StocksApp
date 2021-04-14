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

        guard let appearanceSelection = UserDefaults.standard.appearanceSelected else {
            return
        }
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
        if appearanceSegmentedControl.selectedSegmentIndex == 0 {
            UserDefaults.standard.appearanceSelected = 0
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSegmentedControl.selectedSegmentIndex == 1 {
            UserDefaults.standard.appearanceSelected = 1
            overrideUserInterfaceStyle = .light
        } else if appearanceSegmentedControl.selectedSegmentIndex == 2 {
            UserDefaults.standard.appearanceSelected = 2
            overrideUserInterfaceStyle = .dark
        } else {
            print("selection error")
        }
        
        appearanceSelectedCallback?()
    }
}
