import UIKit

enum StockListViewState {
    case loading
    case error(message: String)
    case loaded
}

protocol StockListViewInput {
    func applyState(_ state: StockListViewState)
}

protocol StockListViewOutput {
    var stocks: [Stock] { get }

    func viewDidLoad()
    func didSelectRow(indexPath: IndexPath)
    func didTapOnSettings()
}

class StockListPresenter {

    var stocks: [Stock] = []

    var coordinator: StockListCoordinator?

    weak var view: (UIViewController & StockListViewInput)?

    private let networkService = NetworkService()

    private func requestCompanies() {
        view?.applyState(.loading)

        networkService.requestCompaniesList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                print(error.reason)
            case .success(let items):
                self.stocks = items
                self.view?.applyState(.loaded)
            }
        }
    }
}

extension StockListPresenter: StockListViewOutput {
    func didTapOnSettings() {
        coordinator?.showSettings()
    }

    func viewDidLoad() {
        requestCompanies()
    }

    func didSelectRow(indexPath: IndexPath) {
        let stock = stocks[indexPath.row]

        coordinator?.showStockDetails(symbol: stock.symbol)
    }
}
