class RestorePresenter {
    weak var view: IRestoreView?

    private let router: IRestoreRouter
    private let accountCreator: IAccountCreator

    private var types = [PredefinedAccountType]()

    init(router: IRestoreRouter, accountCreator: IAccountCreator) {
        self.router = router
        self.accountCreator = accountCreator
    }

}

extension RestorePresenter: IRestoreViewDelegate {

    func viewDidLoad() {
        types = PredefinedAccountType.allCases
    }

    var typesCount: Int {
        return types.count
    }

    func type(index: Int) -> PredefinedAccountType {
        return types[index]
    }

    func didSelect(index: Int) {
        switch types[index] {
        case .mnemonic: router.showRestoreWords(delegate: self)
        case .eos: ()
        case .binance: ()
        }
    }

    func didTapCancel() {
        router.close()
    }

}

extension RestorePresenter: IRestoreDelegate {

    func didRestore(accountType: AccountType, syncMode: SyncMode?) {
        accountCreator.createRestoredAccount(accountType: accountType, syncMode: syncMode)
        router.close()
    }

}
