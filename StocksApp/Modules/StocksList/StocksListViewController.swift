import UIKit
import SkeletonView
import SnapKit

class StocksListViewController: UIViewController {

    // MARK: - Private Properties

    private var stocks: [Stock] = []
    private var logos: [Logo] = []
    private let networkService = NetworkService()

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseId)
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Constants.Colors.appTheme
        configureConstraints()
        requestCompanies()
    }

    // MARK: - Private Methods

    private func requestCompanies() {
        networkService.requestCompaniesList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                print(error.reason)
            case .success(let items):
                self.stocks = items
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
}

// MARK: - UITableViewDataSource

extension StocksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseId) as? StockCell else {
            return UITableViewCell()
        }

        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
//        cell.setupImage(with: logoUrl)

        return cell
    }
}

extension StocksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }

        let stockDetailsVC = StockDetailsViewController()
//        let quote = stocks[selectedIndex.row]
//        stockDetailsVC.quoteName = quote.name

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(stockDetailsVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
// extension Double {
//    func convertUnixTimestampToDate() -> String {
//        let date = Date(timeIntervalSince1970: self)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = DateFormatter.Style.short
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeZone = .current
//
//        return dateFormatter.string(from: date)
//    }
// }
//    private func addFavoriteBarButton() {
//        let defaults = UserDefaults.standard
//        let favoriteArray = defaults.object(forKey: UserDefaultsKey.favoritesKey) as? [String] ?? [String]()
//        let isFavorite = favoriteArray.contains(stock.symbol)
//
//        let starAttributes: [NSAttributedString.Key: Any] =
//            [.foregroundColor: isFavorite ? #colorLiteral(red: 1, green: 0.7927889228, blue: 0.1083463505, alpha: 1) : #colorLiteral(red: 0.7293394804, green: 0.7294487357, blue: 0.7293244004, alpha: 1), .font: UIFont.boldSystemFont(ofSize: 20)]
//        let item = UIBarButtonItem(title: "★", style: .plain, target: self, action: #selector(toggleFavoriteBarButton))
//        item.setTitleTextAttributes(starAttributes, for: .normal)
//
//        navigationItem.rightBarButtonItem = item
//    }

//    @objc private func toggleFavoriteBarButton() {
//        let defaults = UserDefaults.standard
//        var favoriteArray = defaults.object(forKey: UserDefaultsKey.favoritesKey) as? [String] ?? [String]()
//        let wasFavorite = favoriteArray.contains(stock.symbol)
//
//        if wasFavorite {
//            favoriteArray.removeAll { $0 == stock.symbol }
//        } else {
//            favoriteArray.append(stock.symbol)
//        }
//
//        defaults.setValue(favoriteArray, forKey: UserDefaultsKey.favoritesKey)
//
//
//        let starAttributes: [NSAttributedString.Key: Any] =
//            [.foregroundColor: wasFavorite ? #colorLiteral(red: 0.7293394804, green: 0.7294487357, blue: 0.7293244004, alpha: 1) : #colorLiteral(red: 1, green: 0.7927889228, blue: 0.1083463505, alpha: 1) , .font: UIFont.boldSystemFont(ofSize: 20)]
//
//        let item = UIBarButtonItem(title: "★", style: .plain, target: self, action: #selector(toggleFavoriteBarButton))
//        item.setTitleTextAttributes(starAttributes, for: .normal)
//
//        navigationItem.rightBarButtonItem = item
//
//        NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.FavoriteStocksChange),
//                                        object: nil)
//    }
