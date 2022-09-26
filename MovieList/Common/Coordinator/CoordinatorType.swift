import Foundation
import UIKit

protocol CoordinatorType: AnyObject {
    var rootViewController: UIViewController? { get }
    var coordinators: [CoordinatorType] { get set }

    func start()
}

extension CoordinatorType {
    func addCoordinator(_ coordinator: CoordinatorType) {
        coordinators.append(coordinator)
    }

    func removeCoordinator(_ coordinator: CoordinatorType) {
        coordinators = coordinators.filter {
            $0 !== coordinator
        }
    }

    func removeAllCoordinators() {
        coordinators.removeAll()
    }
}
