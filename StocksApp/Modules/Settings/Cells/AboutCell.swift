import UIKit

protocol AboutCellDelegate: AnyObject {
    func didTapDeveloperHashtagButton()
}

class AboutCell: UITableViewCell {

    static let reuseId = "AboutCell"

    // MARK: - UI

    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .appIconForSettings
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var appName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.text = UIApplication.appName ?? ""
        return label
    }()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.text = "\(Constants.LocalizationKey.version.string) \(UIApplication.appVersion ?? "1.0")"
        return label
    }()

    private lazy var craftedByLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Constants.LocalizationKey.developedBy.string
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var developerHashtagButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("@rdscoo1", for: .normal)
        button.addTarget(self, action: #selector(didTapDeveloperHashtag), for: .touchUpInside)
        return button
    }()

    // MARK: - Public property

    weak var delegate: AboutCellDelegate?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [craftedByLabel, developerHashtagButton])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .fill

        contentView.addSubview(appIconImageView)
        contentView.addSubview(appName)
        contentView.addSubview(appVersionLabel)
        contentView.addSubview(stackView)

        appIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.height.width.equalTo(64)
            $0.centerX.equalToSuperview()
        }

        appName.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(32)
        }

        appVersionLabel.snp.makeConstraints {
            $0.top.equalTo(appName.snp.bottom).offset(2)
            $0.left.right.equalToSuperview().inset(32)
        }

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(appVersionLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(4)
        }
    }

    @objc private func didTapDeveloperHashtag() {
        delegate?.didTapDeveloperHashtagButton()
    }
}
