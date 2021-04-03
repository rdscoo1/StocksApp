import UIKit

class NewsViewController: UIViewController {

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseId)
        tableView.dataSource = self
        tableView.rowHeight = 100
        return tableView
    }()

    // MARK: - Private Properties

    private let networkService = NetworkService()
    private var news: [News] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        requestNews()
    }

    // MARK: - Private Methods

    private func requestNews() {
        networkService.requestNewsFor(symbol: "aapl") { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                print(error.reason)
            case .success(let news):
                self.news = news
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId) as? NewsCell else {
            return UITableViewCell()
        }

        let item = news[indexPath.row]
        cell.configure(with: item)

        return cell
    }
}
