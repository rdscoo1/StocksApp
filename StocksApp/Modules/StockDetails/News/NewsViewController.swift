import UIKit

class NewsViewController: UIViewController {

    // MARK: - UI

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.alpha = 0
        return tableView
    }()

    private lazy var presenter: NewsPresenter = {
        let presenter = NewsPresenter()
        presenter.coordinator = NewsCoordinator(viewController: self)
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Property

    var symbol = ""

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.appTheme
        tableView.backgroundColor = Constants.Colors.appTheme

        setupLayout()
        presenter.viewDidLoad(companySymbol: symbol)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setAppearance()
    }

    // MARK: - Private Methods

    private func setupLayout() {
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

    private func setAppearance() {
        guard let appearanceSelection = UserDefaults.standard.appearanceSelected else {
            return
        }

        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
}

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseId) as? NewsCell else {
            return UITableViewCell()
        }

        let item = presenter.news[indexPath.row]
        cell.configure(with: item)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }

        print(selectedIndex)

        presenter.didSelectArticle(indexPath: selectedIndex)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SymbolSettable Conformance to send string from containerVC

extension NewsViewController: SymbolSettable { }

// MARK: - NewsViewInput

extension NewsViewController: NewsViewInput {
    func applyState(_ state: ViewState) {
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
