import UIKit
import ThemeKit
import MarketKit

struct CoinAnalyticsModule {

    static func viewController(fullCoin: FullCoin) -> CoinAnalyticsViewController {
        let service = CoinAnalyticsService(
                fullCoin: fullCoin,
                marketKit: App.shared.marketKit,
                currencyKit: App.shared.currencyKit,
                subscriptionManager: App.shared.subscriptionManager
        )
        let technicalIndicatorService = TechnicalIndicatorService(
                coinUid: fullCoin.coin.uid,
                currencyKit: App.shared.currencyKit,
                marketKit: App.shared.marketKit
        )
        let coinIndicatorViewItemFactory = CoinIndicatorViewItemFactory()
        let viewModel = CoinAnalyticsViewModel(
                service: service,
                technicalIndicatorService: technicalIndicatorService,
                coinIndicatorViewItemFactory: coinIndicatorViewItemFactory
        )

        return CoinAnalyticsViewController(viewModel: viewModel)
    }

}

extension CoinAnalyticsModule {

    enum Rating: String, CaseIterable {
        case excellent
        case good
        case fair
        case poor

        var title: String {
            "coin_analytics.overall_score.\(rawValue)".localized
        }

        var image: UIImage? {
            UIImage(named: "rating_\(rawValue)_24")
        }

        var color: UIColor {
            switch self {
            case .excellent: return .themeGreenD
            case .good: return .themeYellowD
            case .fair: return UIColor(hex: 0xff7a00)
            case .poor: return .themeRedD
            }
        }
    }

}
