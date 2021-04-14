import UIKit

protocol NewsCoordinatorInput {
    func showNewsArticle(news: News)
}

class NewsCoordinator {

    var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension NewsCoordinator: NewsCoordinatorInput {
    func showNewsArticle(news: News) {
        let newsArticleViewController = NewsArticleViewController()
        newsArticleViewController.newsArticle = news
        viewController?.navigationController?.navigationBar.isHidden = true
        viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController?.navigationController?.pushViewController(newsArticleViewController, animated: true)
    }
}
