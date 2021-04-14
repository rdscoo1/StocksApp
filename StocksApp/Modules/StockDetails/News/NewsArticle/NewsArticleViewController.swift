//
//  NewsArticleViewController.swift
//  StocksApp
//
//  Created by Roman Khodukin on 4/7/21.
//

import UIKit

class NewsArticleViewController: UIViewController {

    // MARK: - UI

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.backIcon, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    // MARK: - Public Property

    var newsArticle: News?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.appTheme

        setupUI()
        setupLayout()
    }

    // MARK: - Private Methods

    private func setupUI() {
        guard let newsImage = newsArticle?.image else {
            return
        }

        newsImageView.loadImage(by: newsImage)
        headlineLabel.text = newsArticle?.headline
    }

    private func setupLayout() {
        newsImageView.addSubview(backButton)
        newsImageView.addSubview(headlineLabel)
        view.addSubview(newsImageView)

        newsImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(400)
        }

        backButton.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(12)
            $0.top.equalTo(newsImageView.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.equalToSuperview().offset(12)
        }

        headlineLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
