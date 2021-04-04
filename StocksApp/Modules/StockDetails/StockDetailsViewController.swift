import UIKit

enum Cells {
    case chart
    case news
    case summary
}

class StockDetailsViewController: UIViewController {

    // MARK: - UI

    private let menuViewController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    private let cells: [Cells] = [.chart, .summary, .news]

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.bounces = false
        return cv
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    // MARK: - Public Property

    var symbol: String = ""

    var sendSymbolClosure: ((String) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        menuViewController.delegate = self
        setupLayout()

        print(symbol)
        sendSymbolClosure?(symbol)
    }

    // MARK: - Private Methods

    private func setupLayout() {

        // registering cells (viewControllers)
        collectionView.register(ChartContainerCell.self, forCellWithReuseIdentifier: ChartContainerCell.reuseId)
        collectionView.register(SummaryContainerCell.self, forCellWithReuseIdentifier: SummaryContainerCell.reuseId)
        collectionView.register(NewsContainerCell.self, forCellWithReuseIdentifier: NewsContainerCell.reuseId)

        guard let menuView = menuViewController.view else { return }

        view.addSubview(menuView)
        view.addSubview(collectionView)
        menuView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(64)
        }

        collectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(menuView.snp.bottom)
        }

        menuViewController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Scroll View setup

extension StockDetailsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x / 3
        menuViewController.menuBar.transform = CGAffineTransform(translationX: offset, y: 0)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let item = Int(scrollView.contentOffset.x / view.frame.width)
        let indexPath = IndexPath(item: item, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        collectionView.reloadItems(at: [indexPath])
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        let indexPath = IndexPath(item: item, section: 0)
        menuViewController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - UICollectionViewDataSource

extension StockDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cells[indexPath.row] {
        case .chart:
            guard let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartContainerCell.reuseId, for: indexPath) as? ChartContainerCell else {
                return UICollectionViewCell()
            }
            return chartCell
        case.summary:
            guard let summaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryContainerCell.reuseId, for: indexPath) as? SummaryContainerCell else {
                return UICollectionViewCell()
            }
            return summaryCell
        case .news:
            guard let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsContainerCell.reuseId, for: indexPath) as? NewsContainerCell else {
                return UICollectionViewCell()
            }

            print("👹👹👹\(symbol)👹👹👹")
            newsCell.symbol = symbol

            return newsCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StockDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return .init(width: view.frame.width, height: view.frame.height - 60 - 44 - statusBarFrameHeight)

    }
}

// MARK: - MenuControllerDelegate

extension StockDetailsViewController: MenuControllerDelegate {
    func didTapMenuItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
