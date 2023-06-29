import Combine
import RxSwift

class CexWithdrawConfirmViewModel {
    private let service: CexWithdrawConfirmService
    private let contactLabelService: ContactLabelService?
    private var cancellables = Set<AnyCancellable>()
    private let disposeBag = DisposeBag()

    @Published private(set) var sectionViewItems = [SectionViewItem]()
    @Published private(set) var withdrawing = false

    init(service: CexWithdrawConfirmService, contactLabelService: ContactLabelService?) {
        self.service = service
        self.contactLabelService = contactLabelService

        subscribe(disposeBag, contactLabelService?.stateObservable) { [weak self] _ in
            self?.syncSectionViewItems()
        }

        service.$state
                .sink { [weak self] in self?.sync(state: $0) }
                .store(in: &cancellables)

        sync(state: service.state)
        syncSectionViewItems()
    }

    private func sync(state: CexWithdrawConfirmService.State) {
        switch state {
        case .idle: withdrawing = false
        case .loading: withdrawing = true
        }
    }

    private func syncSectionViewItems() {
        var sectionViewItems: [SectionViewItem] = [
            SectionViewItem(viewItems: mainViewItems())
        ]

        if let cexNetwork = service.cexNetwork {
            sectionViewItems.append(
                    SectionViewItem(viewItems: [
                        .value(title: "cex_withdraw_confirm.network".localized, value: cexNetwork.networkName, type: .regular)
                    ])
            )
        }

        self.sectionViewItems = sectionViewItems
    }

    private func mainViewItems() -> [ViewItem] {
        let contactData = contactLabelService?.contactData(for: service.address)

        var viewItems: [ViewItem] = [
            .subhead(
                    iconName: "arrow_medium_2_up_right_24",
                    title: "cex_withdraw_confirm.you_withdraw".localized,
                    value: service.cexAsset.coinName
            ),
            .amount(
                    iconUrl: service.cexAsset.coin?.imageUrl,
                    iconPlaceholderImageName: "placeholder_circle_32",
                    coinAmount: ValueFormatter.instance.formatFull(coinValue: CoinValue(kind: .cexAsset(cexAsset: service.cexAsset), value: service.amount)) ?? "n/a".localized,
//                    currencyAmount: currencyValue.flatMap { ValueFormatter.instance.formatFull(currencyValue: $0) },
                    currencyAmount: nil,
                    type: .neutral
            ),
            .address(
                    title: "send.confirmation.to".localized,
                    value: service.address,
                    contactAddress: contactData?.contactAddress
            )
        ]

        if let contactName = contactData?.name {
            viewItems.append(.value(title: "send.confirmation.contact_name".localized, value: contactName, type: .regular))
        }

        return viewItems
    }

}

extension CexWithdrawConfirmViewModel {

    var confirmWithdrawPublisher: AnyPublisher<String, Never> {
        service.confirmWithdrawPublisher
    }

    var errorPublisher: AnyPublisher<String, Never> {
        service.errorPublisher
                .map { _ in "cex_withdraw_confirm.withdraw_failed".localized }
                .eraseToAnyPublisher()
    }

    func onTapWithdraw() {
        service.withdraw()
    }

}

extension CexWithdrawConfirmViewModel {

    struct SectionViewItem {
        let viewItems: [ViewItem]
    }

    enum ViewItem {
        case subhead(iconName: String, title: String, value: String)
        case amount(iconUrl: String?, iconPlaceholderImageName: String, coinAmount: String, currencyAmount: String?, type: AmountType)
        case address(title: String, value: String, contactAddress: ContactAddress?)
        case value(title: String, value: String, type: ValueType)
    }

}