import UIKit

class StockDetailsViewController: UIViewController {

    private let menuScrollView = UIScrollView()
    private let containerView = UIView()

    private var currentController: UIViewController! {
        didSet {
            add(asChildViewController: currentController)
        }
        willSet {
            guard let _ = currentController else {
                return
            }
            remove(asChildViewController: currentController)
        }
    }

    private lazy var chartController: ChartViewController = {
        return ChartViewController()
    }()

    private lazy var newsController: NewsViewController = {
        return NewsViewController()
    }()

    private lazy var summaryController: SummaryViewController = {
        return SummaryViewController()
    }()

    private var selectedTab: Int = 0 {
        didSet {
            guard let tabView = menuScrollView.subviews[selectedTab] as? TabView else {
                return
            }
            tabView.setupActiveView()
            if selectedTab == 0 {
                currentController = chartController

            } else if selectedTab == 1 {
                currentController = newsController

            } else if selectedTab == 2 {
                currentController = summaryController
            }
        }
        willSet {
            guard let tabView = menuScrollView.subviews[selectedTab] as? TabView else {
                return
            }
            tabView.setupDefaultView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc
    private func didTapOnHistoryBarButtonItem(_ sender: UIBarButtonItem) {
        switch selectedTab {
        case 0:
            showCharts()
        case 1:
            showNews()
        case 2:
            showSummary()
        default:
            return
        }
    }

    // MARK: - Public methods

    private var selectedIndexTab: Int?

    func setTab(at index: Int) {
        selectedIndexTab = index
        if menuScrollView != nil {
            selectedTab = index
        }
    }

    // MARK: - Rounting

    private func showCharts() {
        let controller = ChartViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showNews() {
        let controller = NewsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showSummary() {
        let controller = SummaryViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Configure View Controllers

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

}

extension StockDetailsViewController: SelectedTabViewProtocol {

    func didSelectTab(_ index: Int) {
        selectedTab = index
    }

}

extension StockDetailsViewController {

    // MARK: - Start Configure View

    private func setupUI() {
        view.addSubview(containerView)
        view.addSubview(menuScrollView)

        menuScrollView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        containerView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(menuScrollView.snp.bottom)
        }
    }

    private func configureView() {
        setupUI()
        setupMenu()
    }

    private func setupMenu() {
        let titles: [String] = [
            "Charts",
            "News",
            "Summary"
        ]

        let marginTop: CGFloat = 5
        let margin: CGFloat = 10
        var x: CGFloat = margin

        for index in 0..<titles.count {
            let size = CGRect(x: x, y: marginTop, width: TabView.width, height: TabView.height)
            let tabView = TabView(frame: size, title: titles[index])
            tabView.delegate = self
            tabView.tag = index
            menuScrollView.addSubview(tabView)
            x += (TabView.width + margin)
        }
        menuScrollView.contentSize = CGSize(width: x, height: TabView.height)
        selectedTab = selectedIndexTab ?? 0
    }

}
