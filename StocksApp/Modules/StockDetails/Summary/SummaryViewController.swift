import UIKit

class SummaryViewController: UIViewController {

    // MARK: - UI

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Summary", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .red
        return button
    }()

    // MARK: - Private Properties

    private let networkService = NetworkService()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(32)
        }

        requestCompanyInfo()
    }

    private func requestCompanyInfo() {
        networkService.requestCompanyInfo(symbol: "aapl") { [weak self] response in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let company):
                print(company)
            }
        }
    }
}
