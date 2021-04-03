import UIKit
import SkeletonView
import SnapKit

class StocksListViewController: UIViewController {

    // MARK: - Private Properties

    private var stocks: [Stock] = []
    private var logos: [Logo] = []
    private let networkService = NetworkService()
    private let tableViewDataSource = StocksListTableViewDataSource()

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseId)
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Constants.Colors.appTheme
        configureConstraints()
        requestCompanies()
        configureNavBarButton()
    }

    // MARK: - Private Methods

    private func requestCompanies() {
        networkService.requestCompaniesList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                print(error.reason)
            case .success(let items):
                self.tableViewDataSource.stocks = items
                self.tableView.reloadData()
                self.requestCompanyLogos()
            }
        }
    }

    private func requestCompanyLogos() {
        for stock in stocks {
            networkService.requestLogoUrl(for: stock.companyName) { response in
                switch response {
                case .failure(let error):
                    print(error.reason)
                case .success(let imageUrl):
                    self.logos.append(Logo(url: imageUrl))
                    print(self.logos)
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func requestQuote() {
        for (index, stock) in stocks.enumerated() {
            networkService.requestQuote(for: stock.symbol) { response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let item):
                    self.stocks[index].symbol = item.symbol
                    self.stocks[index].latestPrice = item.latestPrice
                    self.stocks[index].change = item.change
                }
            }
        }
    }

    private func configureConstraints() {
        view.addSubview(tableView)

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
        let settingsViewController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        navigationController?.present(navController, animated: true)
    }
}

extension StocksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedIndex = tableView.indexPathForSelectedRow else {
//            return
//        }

//        print(selectedIndex)
        let stockDetailsVC = StockDetailsViewController()
//        let stock = stocks[selectedIndex.row]
//        stockDetailsVC.symbol = stock.symbol

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(stockDetailsVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
