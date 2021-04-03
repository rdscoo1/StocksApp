import UIKit
import MessageUI
import StoreKit
import SafariServices

enum SettingsSections {
    case appearance
    case support([Setting])
    case about
}

class SettingsViewController: UIViewController {

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(AppearanceCell.self, forCellReuseIdentifier: AppearanceCell.reuseId)
        tableView.register(SettingsSupportCell.self, forCellReuseIdentifier: SettingsSupportCell.reuseId)
        tableView.register(AboutCell.self, forCellReuseIdentifier: AboutCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Constants.Colors.settingsBackground
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var sections: [SettingsSections] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var supportItems: [Setting] = SettingsProvider.shared.getSettingsSupport()

    // Links
    let appStoreURLStringForRating = "itms-apps://apple.com/app/id1534974973"
    let appStoreURLStringForShareSheet = "https://apps.apple.com/us/app/id1534974973"
    let gitHubURLString = "https://github.com/rdscoo1"
    let supportEmail = "romakhodukin@gmail.com"

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupLayout()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        /// This will makes sure when the user hits this screen, that the appearance is synced to their device settings
        setAppearance()
    }

    // MARK: - Private Methods

    private func setupUI() {
        //        let supportItems: [Setting] = SettingsProvider.shared.getSettingsSupport()

        sections += [.appearance, .support(supportItems), .about]
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Скрыть",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissVC))
        navigationItem.title = Constants.LocalizationKey.settings.string
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func launchHelpfulLink() {
        let urlString = gitHubURLString

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self

            present(vc, animated: true)
        }
    }

    private func promptRating() {
        if let url = URL(string: appStoreURLStringForRating) {
            UIApplication.shared.open(url)
        } else {
            print("error with app store URL")
        }
    }

    private func launchShareSheet() {
        if let appURL = NSURL(string: appStoreURLStringForShareSheet) {

            let objectsToShare: [Any] = [appURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = tableView

            self.present(activityVC, animated: true, completion: nil)
        }
    }

    private func setAppearance() {

        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "appearanceSelection")
//        appearanceSegmentedControl.selectedSegmentIndex = appearanceSelection

        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .unspecified
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .appearance:
            return 1
        case .support(let items):
            return items.count
        case .about:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .appearance:
            guard let appearanceCell = tableView.dequeueReusableCell(withIdentifier: AppearanceCell.reuseId, for: indexPath) as? AppearanceCell else {
                return UITableViewCell()
            }

            return appearanceCell
        case .support(let items):
            guard let supportCell = tableView.dequeueReusableCell(withIdentifier: SettingsSupportCell.reuseId, for: indexPath) as? SettingsSupportCell else {
                return UITableViewCell()
            }

            let supportItem = items[indexPath.row]
            supportCell.configure(with: supportItem)

            return supportCell
        case .about:
            guard let aboutCell = tableView.dequeueReusableCell(withIdentifier: AboutCell.reuseId, for: indexPath) as? AboutCell else {
                return UITableViewCell()
            }

            aboutCell.delegate = self

            return aboutCell
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath {
        case [1, 1]: launchHelpfulLink()
            tableView.deselectRow(at: indexPath, animated: true)
        case [1, 2]: composeShareEmail()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2, 0]: promptRating()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2, 1]: launchShareSheet()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2, 2]: composeShareEmail()
            tableView.deselectRow(at: indexPath, animated: true)
        default: print("no class function triggered for index path: \(indexPath)")
        }
    }
}

extension SettingsViewController: AboutCellDelegate {
    func didTapDeveloperHashtagButton() {
        let urlString = gitHubURLString

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
}

// MARK: - SFSafariViewControllerDelegate

extension SettingsViewController: SFSafariViewControllerDelegate { }

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsViewController: MFMailComposeViewControllerDelegate {

    func composeShareEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let messageBody: String
        let deviceModelName = UIDevice.modelName
        let iOSVersion = UIDevice.current.systemVersion
        let topDivider = "------- Developer Info -------"
        let divider = "------------------------------"

        if let appVersion = UIApplication.appVersion {

            messageBody = "\n\n\n\n\(topDivider)\nApp version: \(appVersion)\nDevice model: \(deviceModelName)\niOS version: \(iOSVersion)\n\(divider)"
        } else {
            messageBody = "\n\n\n\n\(topDivider)\nDevice model: \(deviceModelName)\niOS version: \(iOSVersion)\n\(divider)"
        }

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([supportEmail])
        mailComposerVC.setSubject("Your App Feedback")
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        return mailComposerVC
    }

    /// This alert gets shown if the device is a simulator, doesn't have Apple mail set up, or if mail in not available due to connectivity issues.
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "Could Not Send Email",
            message: """
                     Your device could not send email. Please check email configuration and internet connection and try again.
                     """,
            preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
