import UIKit

// MARK: - UITableViewDataSource Conformance

class StocksListTableViewDataSource: NSObject, UITableViewDataSource {

    var stocks = [Stock]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseId) as? StockCell else {
            return UITableViewCell()
        }

        let quote = stocks[indexPath.row]
        cell.configure(with: quote)

        return cell
    }
}
