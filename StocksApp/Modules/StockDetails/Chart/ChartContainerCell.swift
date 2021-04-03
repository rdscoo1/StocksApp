import UIKit

class ChartContainerCell: UICollectionViewCell {

    static let reuseId = String(describing: self)

    // MARK: - Private Properties

    private let chartViewController = ChartViewController()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let chartViewControllerView = chartViewController.view else {
            return
        }

        contentView.addSubview(chartViewControllerView)
        chartViewControllerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
