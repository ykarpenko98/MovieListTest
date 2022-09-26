//
//  DetailsCoordinator.swift
//  MovieList
//
//  Created by anduser on 22.09.2022.
//

import Foundation
import UIKit

final class DetailsCoordinator: NSObject, CoordinatorType {

    private let navigationController: UINavigationController?
    private let movie: MovieViewModel

    var rootViewController: UIViewController?
    var coordinators: [CoordinatorType] = []

    init(navigationController: UINavigationController?,
         movie: MovieViewModel) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
        let viewModel = DetailsViewModel(movie: movie)
        let viewController = DetailsViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        rootViewController = viewController
    }
}
