import Combine
import RxRelay
import RxSwift

class ManageAccountsService {
    private let accountManager: AccountManager
    private let cloudBackupManager: CloudBackupManager
    private var cancellables = Set<AnyCancellable>()

    private let itemsRelay = PublishRelay<[Item]>()
    private(set) var items = [Item]() {
        didSet {
            itemsRelay.accept(items)
        }
    }

    init(accountManager: AccountManager, cloudBackupManager: CloudBackupManager) {
        self.accountManager = accountManager
        self.cloudBackupManager = cloudBackupManager

        accountManager.activeAccountPublisher
            .sink { [weak self] _ in self?.syncItems() }
            .store(in: &cancellables)

        accountManager.accountsPublisher
            .sink { [weak self] _ in self?.syncItems() }
            .store(in: &cancellables)

        cloudBackupManager.$oneWalletItems
            .sink { [weak self] _ in self?.syncItems() }
            .store(in: &cancellables)

        syncItems()
    }

    private func syncItems() {
        let activeAccount = accountManager.activeAccount
        items = accountManager.accounts.map { account in
            let cloudBackedUp = cloudBackupManager.backedUp(uniqueId: account.type.uniqueId())
            return Item(account: account, cloudBackedUp: cloudBackedUp, isActive: account == activeAccount)
        }
    }
}

extension ManageAccountsService {
    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    var lastCreatedAccount: Account? {
        accountManager.popLastCreatedAccount()
    }

    var hasAccounts: Bool {
        !accountManager.accounts.isEmpty
    }

    func set(activeAccountId: String) {
        accountManager.set(activeAccountId: activeAccountId)
    }
}

extension ManageAccountsService {
    struct Item {
        let account: Account
        let cloudBackedUp: Bool
        let isActive: Bool

        var hasAlertDescription: Bool {
            !(account.backedUp || cloudBackedUp)
        }

        var hasAlert: Bool {
            !account.backedUp
        }
    }
}
