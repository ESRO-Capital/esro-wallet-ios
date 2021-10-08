import RxSwift
import RxRelay
import RxCocoa

class MarketViewModel {
    private let service: MarketService
    private let disposeBag = DisposeBag()

    private let currentTabRelay: BehaviorRelay<MarketModule.Tab>

    init(service: MarketService) {
        self.service = service

        currentTabRelay = BehaviorRelay<MarketModule.Tab>(value: service.currentTab ?? .overview)
    }

}

extension MarketViewModel {

    var currentTabDriver: Driver<MarketModule.Tab> {
        currentTabRelay.asDriver()
    }

    var tabs: [MarketModule.Tab] {
        MarketModule.Tab.allCases
    }

    func onSelect(tab: MarketModule.Tab) {
        service.currentTab = tab
        currentTabRelay.accept(tab)
    }

}
