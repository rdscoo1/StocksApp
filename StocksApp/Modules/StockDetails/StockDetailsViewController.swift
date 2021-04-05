import UIKit

protocol SymbolSettable where Self: UIViewController {
    var symbol: String { get set }
}

class StockDetailsViewController: UIViewController {

    // MARK: - UI

    private let menuViewController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        return collectionView
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var viewControllers: [UIViewController] = {
        let viewControllers: [UIViewController] = [ChartViewController(), SummaryViewController(), NewsViewController()]
        for viewController in viewControllers {
            addChildContentViewController(viewController)
        }
        return viewControllers
    }()

    // MARK: - ChildViewControllers

    private func addChildContentViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }

    // MARK: - Public Property

    var symbol: String = ""

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        menuViewController.delegate = self
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setAppearance()
    }

    // MARK: - Private Methods

    private func setAppearance() {
        let appearanceSelection = UserDefaults.standard.integer(forKey: "appearanceSelection")

        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }

    private func setupLayout() {

        // registering cells (viewControllers)
        collectionView.register(HostedViewCell.self, forCellWithReuseIdentifier: HostedViewCell.reuseIdentifier)

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
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        let indexPath = IndexPath(item: item, section: 0)
        print("indexPath: \(indexPath), item: \(item)")
        menuViewController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - UICollectionViewDataSource

extension StockDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostedViewCell.reuseIdentifier, for: indexPath) as? HostedViewCell else {
            fatalError("Expected cell with reuse identifier: \(HostedViewCell.reuseIdentifier)")
        }

        let viewController = viewControllers[indexPath.row]

        cell.hostedView = viewController.view
        (viewController as? SymbolSettable)?.symbol = symbol

        return cell
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

        // Delegate method implementation (scroll to the right page when the corresponding Menu "Button"(Item) is pressed
        if #available(iOS 14.0, *) { // bug with collectionView paging in iOS 14
            let rect = self.collectionView.layoutAttributesForItem(at: indexPath)?.frame
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.collectionView.scrollRectToVisible(rect!, animated: false)
            })
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
