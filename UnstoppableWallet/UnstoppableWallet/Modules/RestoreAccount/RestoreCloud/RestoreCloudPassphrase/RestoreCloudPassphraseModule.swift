import Foundation
import UIKit

class RestoreCloudPassphraseModule {

    static func restorePassword(item: RestoreCloudModule.RestoredBackup, returnViewController: UIViewController?) -> UIViewController {
        let service = RestoreCloudPassphraseService(
                iCloudManager: App.shared.cloudAccountBackupManager,
                accountFactory: App.shared.accountFactory,
                accountManager: App.shared.accountManager,
                item: item
        )
        let viewModel = RestoreCloudPassphraseViewModel(service: service)
        let controller = RestoreCloudPassphraseViewController(viewModel: viewModel, returnViewController: returnViewController)

        return controller
    }


}
