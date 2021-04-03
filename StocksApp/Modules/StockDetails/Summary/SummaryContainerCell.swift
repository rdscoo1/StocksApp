import UIKit

class SummaryContainerCell: UICollectionViewCell {

    static let reuseId = "SummaryContainerCell"

    // MARK: - Private Properties

    private let summaryViewController = SummaryViewController()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let summaryViewControllerView = summaryViewController.view else {
            return
        }

        contentView.addSubview(summaryViewControllerView)
        summaryViewControllerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
