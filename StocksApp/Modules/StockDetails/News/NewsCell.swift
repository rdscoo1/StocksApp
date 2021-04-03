import UIKit

class NewsCell: UITableViewCell {

    static let reuseId = String(describing: self)

    // MARK: - UI

    private lazy var headline: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var summary: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
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

    private func setupLayout() {
        contentView.addSubview(headline)
        contentView.addSubview(summary)

        headline.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(8)
        }

        summary.snp.makeConstraints {
            $0.top.equalTo(headline.snp.bottom).offset(4)
            $0.left.right.equalTo(headline)
            $0.bottom.equalToSuperview().offset(8)
        }
    }
}

// MARK: - ConfigurableView

extension NewsCell: ConfigurableView {
    func configure(with model: News) {
        headline.text = model.headline
        summary.text = model.summary
    }
}
