import UIKit
import SkeletonView
import SnapKit

class StocksListViewController: UIViewController {

    // MARK: - Private Properties

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    lazy var presenter: StockListViewOutput = {
        let presenter = StockListPresenter()
        presenter.coordinator = StockListCoordinator(viewController: self)
        presenter.view = self
        return presenter
    }()

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseId)
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alpha = 0.0
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.appTheme
        tableView.backgroundColor = Constants.Colors.appTheme

        configureConstraints()
        configureNavBarButton()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAppearance()
    }

    // MARK: - Private Methods

    private func configureConstraints() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.center.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureNavBarButton() {
        let settingsBarButton = UIBarButtonItem(image: .settingsIcon, style: .plain, target: self, action: #selector(didTapOnSettings))
        settingsBarButton.tintColor = .darkGray
        navigationItem.leftBarButtonItem = settingsBarButton
    }

    @objc private func didTapOnSettings() {
        presenter.didTapOnSettings()
    }

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
}

// MARK: - UITableViewDataSource Conformance

extension StocksListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseId) as? StockCell else {
            return UITableViewCell()
        }

        let quote = presenter.stocks[indexPath.row]
        cell.configure(with: quote)

        return cell
    }
}

// MARK: - UITableViewDelegate Conformance

extension StocksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }

        presenter.didSelectRow(indexPath: selectedIndex)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StocksListViewController: StockListViewInput {
    func applyState(_ state: StockListViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            tableView.alpha = 0
        case .loaded:
            activityIndicator.stopAnimating()
            tableView.alpha = 1
            tableView.reloadData()
        case .error(let message):
             print(message)
        }
    }
}
