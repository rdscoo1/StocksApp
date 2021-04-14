import UIKit
import SnapKit

class StockCell: UITableViewCell {

    static let reuseId = String(describing: self)

    // MARK: - UI

    private let containerView = UIView()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "symbol"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = Constants.Colors.label
        return label
    }()

    private lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Constants.Colors.label
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = Constants.Colors.label
        return label
    }()

    private lazy var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "Price Change"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Constants.Colors.label
        return label
    }()

    private let priceChangeArrow = UIImageView()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.setImage(.starIcon, for: .normal)
        button.tintColor = Constants.Colors.favoriteButtonGray
        return button
    }()

    private let notFavoriteImage = UIImage.starIcon.tinted(color: Constants.Colors.favoriteButtonGray)
    private let isFavoriteImage = UIImage.starIcon.tinted(color: Constants.Colors.isFavoriteButtonYellow)

    // MARK: - Private Properties

    var isFavorite: Bool = false

    private let inset: CGFloat = 8

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        setupUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            containerView.backgroundColor = Constants.Colors.cellHighlightedBackground
        } else {
            containerView.backgroundColor = Constants.Colors.cellBackground
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = false

        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }

    @objc private func didTapFavoriteButton() {
        if isFavorite {
            favoriteButton.tintColor = Constants.Colors.favoriteButtonGray
        } else {
            favoriteButton.tintColor = Constants.Colors.isFavoriteButtonYellow
        }
        isFavorite.toggle()
    }

    private func configureConstraints() {
        containerView.addSubview(logoImageView)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(companyNameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(priceChangeLabel)
        containerView.addSubview(priceChangeArrow)
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(inset * 2)
            $0.bottom.equalToSuperview().inset(inset)
        }

        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(symbolLabel.snp.centerY)
            $0.right.equalToSuperview().inset(inset)
        }

        priceChangeLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(2)
            $0.right.equalTo(priceLabel.snp.right)
        }

        priceChangeArrow.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.width.equalTo(10)
            $0.centerY.equalTo(priceChangeLabel.snp.centerY)
            $0.right.equalTo(priceChangeLabel.snp.left).offset(-4).priority(.required)
        }

        logoImageView.snp.makeConstraints {
            $0.height.width.equalTo(inset * 6)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(inset)
        }

        favoriteButton.snp.makeConstraints {
            $0.height.width.equalTo(inset * 2)
            $0.centerY.equalTo(symbolLabel.snp.centerY)
            $0.right.lessThanOrEqualTo(priceLabel.snp.left).offset(-6)
        }

        symbolLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.top).offset(4)
            $0.left.equalTo(logoImageView.snp.right).offset(inset)
            $0.right.equalTo(favoriteButton.snp.left).offset(-6)
        }

        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(symbolLabel.snp.bottom).offset(2)
            $0.right.lessThanOrEqualTo(priceChangeArrow.snp.left).offset(-4)
            $0.left.equalTo(symbolLabel.snp.left)
        }
    }

    // Configure priceChangeLabel

    private func setPriceChangeLabel(with stock: Stock) {
        let currencyPriceChange = stock.latestPrice * abs(stock.change) / 100 // calculate price change in USD
        let priceChange = String(format: "%.2f", currencyPriceChange)

        self.priceChangeLabel.text = "\(priceChange) $ (\(abs(stock.change))%)"

        switch stock.change {
        case let val where val > 0:
            priceChangeLabel.textColor = Constants.Colors.greenColor
            priceChangeArrow.image = .rectangleArrowUp
            priceChangeArrow.tintColor = .green
        case let val where val < 0:
            priceChangeLabel.textColor = Constants.Colors.redColor
            priceChangeArrow.image = .rectangleArrowDown
            priceChangeArrow.tintColor = .red
        default:
            priceChangeLabel.textColor = .black
            priceChangeArrow.image = nil
        }
    }
}

// MARK: - ConfigurableView 

extension StockCell: ConfigurableView {
    func configure(with model: Stock) {
        logoImageView.loadImage(by: model.companyLogoUrl)
        symbolLabel.text = model.symbol
        companyNameLabel.text = model.companyName
        priceLabel.text = "\(model.latestPrice) $"
        setPriceChangeLabel(with: model)
    }
}
