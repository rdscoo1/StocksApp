import UIKit

class NewsContainerCell: UICollectionViewCell {

    static let reuseId = "NewsContainerCell"

    // MARK: - Private Properties

    private let newsViewController = NewsViewController()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

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
