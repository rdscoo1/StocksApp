import UIKit

class MenuCell: UICollectionViewCell {

    // MARK: - Reuse identifier

    static let reuseId = String(describing: self)

    // MARK: - UI

    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu Item"
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()

    override var isSelected: Bool {
        didSet {
            itemNameLabel.textColor = isSelected ? .black : .lightGray
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(itemNameLabel)
        itemNameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method

    func configure(with menuItemName: String) {
        itemNameLabel.text = menuItemName
    }
}
