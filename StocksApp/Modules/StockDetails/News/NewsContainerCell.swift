import UIKit

class NewsContainerCell: UICollectionViewCell {

    static let reuseId = "NewsContainerCell"

    // MARK: - Private Properties

    private let newsViewController = NewsViewController()

    // MARK: - Public Property

    var symbol = ""

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        let vc = StockDetailsViewController()
        vc.sendSymbolClosure = { [weak self] symbol in
            print("Hello")
            print(symbol)
        }

        print("⚡️⚡️⚡️\(symbol)⚡️⚡️⚡️")

        newsViewController.symbol = symbol

        guard let newsViewControllerView = newsViewController.view else {
            return
        }

        contentView.addSubview(newsViewControllerView)
        newsViewControllerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
