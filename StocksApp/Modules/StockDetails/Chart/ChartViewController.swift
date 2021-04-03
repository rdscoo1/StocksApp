import UIKit

class ChartViewController: UIViewController {

    // MARK: - UI

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Charts", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .blue
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.right.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}
