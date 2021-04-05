import UIKit

protocol StockListCoordinatorInput {
    func showSettings()
    func showStockDetails(symbol: String)
}

class StockListCoordinator {
    var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension StockListCoordinator: StockListCoordinatorInput {
    func showStockDetails(symbol: String) {
        let stockDetailsVC = StockDetailsViewController()
        stockDetailsVC.symbol = symbol
        viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController?.navigationController?.pushViewController(stockDetailsVC, animated: true)
    }

    func showSettings() {
        let settingsViewController = SettingsViewController()
        viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController?.navigationController?.pushViewController(settingsViewController, animated: true)
    }
}
