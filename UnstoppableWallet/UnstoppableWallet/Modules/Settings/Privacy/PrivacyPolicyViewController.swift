import UIKit
import ThemeKit
import SectionsTableView
import ComponentKit

class PrivacyPolicyViewController: ThemeViewController {
    private let config: Config

    private let tableView = SectionsTableView(style: .grouped)

    init(config: Config) {
        self.config = config

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.title

        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        tableView.sectionDataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.registerCell(forClass: MarkdownTextCell.self)
        tableView.registerCell(forClass: MarkdownListItemCell.self)

        tableView.buildSections()
    }

    private var privacySections: [SectionProtocol] {
        var infoRows = [RowProtocol]()

        let descriptionString = NSAttributedString(string: config.description, attributes: [.font: UIFont.body, .foregroundColor: UIColor.themeBran])
        infoRows.append(MarkdownViewController.textRow(id: "description-cell", attributedString: descriptionString, delegate: nil))

        for viewItem in config.viewItems {
            let viewItemString = NSAttributedString(string: viewItem, attributes: [.font: UIFont.body, .foregroundColor: UIColor.themeBran])
            infoRows.append(MarkdownViewController.listItemRow(id: "\(viewItem)-cell", attributedString: viewItemString, prefix: "•", tightTop: false, tightBottom: false))
        }

        return [
            Section(
                    id: "privacy-section",
                    footerState: .margin(height: .margin32),
                    rows: infoRows
            )
        ]
    }

}

extension PrivacyPolicyViewController: SectionsDataSource {

    func buildSections() -> [SectionProtocol] {
        privacySections
    }

}
extension PrivacyPolicyViewController {

    struct Config {
        let title: String
        let description: String
        let viewItems: [String]

        static var privacy: Config {
            Config(
                    title: "settings.privacy".localized,
                    description: "settings.privacy.description".localized(AppConfig.appName),
                    viewItems: [
                        "settings.privacy.statement.user_data_storage".localized,
                        "settings.privacy.statement.data_usage".localized,
                        "settings.privacy.statement.data_privacy".localized,
                        "settings.privacy.statement.user_account".localized
                    ])
        }

    }

}
