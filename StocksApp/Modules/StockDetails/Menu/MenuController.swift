import UIKit

protocol MenuControllerDelegate: AnyObject {
    func didTapMenuItem(indexPath: IndexPath)
}

class MenuController: UICollectionViewController {

    // MARK: - Private Properties

    private let menuItemNames = [Constants.LocalizationKey.chart.string, Constants.LocalizationKey.summary.string, Constants.LocalizationKey.news.string]

    lazy var menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    weak var delegate: MenuControllerDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseId)

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }

        view.addSubview(menuBar)
        menuBar.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.height.equalTo(5)
            $0.width.equalTo(view.snp.width).dividedBy(3)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MenuController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseId, for: indexPath) as? MenuCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(with: menuItemNames[indexPath.item])

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MenuController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 14.0, *) { // bug with collectionView paging in iOS 14
            let x = view.frame.width / 3 * CGFloat(indexPath.item)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.menuBar.transform = CGAffineTransform(translationX: x, y: 0)
            })
        }

        delegate?.didTapMenuItem(indexPath: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return .init(width: width / 3, height: view.frame.height)
    }
}
