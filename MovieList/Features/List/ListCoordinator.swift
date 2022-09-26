import Foundation
import UIKit

final class ListCoordinator: NSObject, CoordinatorType, UINavigationControllerDelegate {
    private var navigationController: UINavigationController?
    var rootViewController: UIViewController?
    var coordinators: [CoordinatorType] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController?.delegate = self
        
        let viewModel = ListViewModel(movieService: MovieService())
        let viewController = ListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewModel.navigationDelegate = self
        
        rootViewController = viewController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        coordinators.forEach {
            if $0.rootViewController === fromViewController {
                removeCoordinator($0)
            }
        }
    }
}


extension ListCoordinator: ListViewModelNavigationDelegate {
    func showDetails(for movie: MovieViewModel) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, movie: movie)
        detailsCoordinator.start()
        addCoordinator(detailsCoordinator)
        
        navigationController?.pushViewController(detailsCoordinator.rootViewController!, animated: true)
    }
}
