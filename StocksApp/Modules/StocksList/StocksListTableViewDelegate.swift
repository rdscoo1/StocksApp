import UIKit

// MARK: - UITableViewDelegate Conformance

class StocksListTableViewDelegate: NSObject, UITableViewDelegate {

    var stocks = [Stock]()

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            return
        }

        let stockDetailsVC = StockDetailsViewController()
        let quote = stocks[selectedIndex.row]
//        stockDetailsVC.quoteName = quote.name

//        navigationController?.pushViewController(stockDetailsVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
