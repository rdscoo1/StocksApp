import UIKit

// MARK: - SelectedTabViewProtocol

protocol SelectedTabViewProtocol: AnyObject {
    func didSelectTab(_ index: Int)
}

class TabView: UIView {

    // MARK: - Private Properties

    static let height: CGFloat = 40
    static let width: CGFloat = 96

    private let marginLeftRight: CGFloat = 6
    private let marginTopBottom: CGFloat = 15
    private let heightTitleLabel: CGFloat = 40

    // MARK: - UI

    private var button: UIButton!

    // MARK: - Public Properties

    weak var delegate: SelectedTabViewProtocol?

    // MARK: - Init

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        configureButton(title: title)
        configureTabView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setupActiveView() {
        clipsToBounds = true
        backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
    }

    func setupDefaultView() {
        clipsToBounds = false
        backgroundColor = .white
        button.setTitleColor(.lightGray, for: .normal)
        button.isEnabled = true
    }

}

extension TabView {

    // MARK: - Start configure

    private func configureTabView() {
        layer.cornerRadius = 8
        backgroundColor = .white
    }

    private func configureButton(title: String) {
        button = UIButton(frame: bounds)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(tabViewButtonPressed(_:)), for: .touchUpInside)
        addSubview(button)
    }

    @objc private func tabViewButtonPressed(_ sender: UIButton) {
        delegate?.didSelectTab(tag)
    }
}
