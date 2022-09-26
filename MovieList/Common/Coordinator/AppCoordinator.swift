import Foundation
import UIKit

protocol AppCoordinatorType {
    func launch()
}

final class AppCoordinator: AppCoordinatorType {

    private let window: UIWindow
    private let navigationController: UINavigationController
    private var coordinators: [CoordinatorType] = []

    init(window: UIWindow,
         navigationController: UINavigationController = .init()) {
        self.window = window
        self.navigationController = navigationController
    }

    func launch() {
        window.rootViewController = navigationController
        let coordinator = ListCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinators.append(coordinator)
        navigationController.pushViewController(coordinator.rootViewController!, animated: false)
    }
}
