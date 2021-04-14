import UIKit

protocol NewsViewInput {
    func applyState(_ state: ViewState)
}

protocol NewsViewOutput {
    var news: [News] { get }

    func viewDidLoad(companySymbol: String)
    func didSelectArticle(indexPath: IndexPath)
}

class NewsPresenter {

    var news: [News] = []

    weak var view: (UIViewController & NewsViewInput)?

    var coordinator: NewsCoordinator?

    private let networkService = NetworkService()

    private func requestNews(companyName: String) {
        view?.applyState(.loading)

        networkService.requestNewsFor(symbol: companyName) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                self.view?.applyState(.error(message: error.reason))
            case.success(let items):
                self.news = items
                self.view?.applyState(.loaded)
            }
        }
    }

}

extension NewsPresenter: NewsViewOutput {
    func didSelectArticle(indexPath: IndexPath) {
        let item = news[indexPath.row]

        coordinator?.showNewsArticle(news: item)
    }

    func viewDidLoad(companySymbol: String) {
        requestNews(companyName: companySymbol)
    }
}
