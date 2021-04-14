import UIKit

class NewsCell: UITableViewCell {

    static let reuseId = String(describing: self)

    // MARK: - UI

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    private lazy var publishDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method

    private func setupLayout() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(headlineLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(publishDateLabel)

        photoImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        headlineLabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(photoImageView.snp.left).offset(-8)
        }

        sourceLabel.snp.makeConstraints {
            $0.bottom.equalTo(photoImageView.snp.bottom)
            $0.left.equalTo(headlineLabel)
        }

        publishDateLabel.snp.makeConstraints {
            $0.left.equalTo(sourceLabel.snp.right).offset(4)
            $0.centerY.equalTo(sourceLabel)
        }
    }
}

// MARK: - ConfigurableView

extension NewsCell: ConfigurableView {
    func configure(with model: News) {
        photoImageView.loadImage(by: model.image)
        headlineLabel.text = model.headline
        sourceLabel.text = model.source
        publishDateLabel.text = "07.04.2021"
    }
}
