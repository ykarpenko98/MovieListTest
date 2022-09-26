import Foundation
import UIKit

typealias DetailsViewSnapshot = NSDiffableDataSourceSnapshot<DetailsSection, DetailsSectionItem>

enum DetailsSection: String, CaseIterable {
    case details
}

enum DetailsSectionItem: Hashable {
    case image(imagePath: String?)
    case text(title: String, description: String)
}

protocol DetailsViewModelType {
    func didLoad()
}

protocol DetailsViewModelDelegate: AnyObject {
    func updateWithSnapshot(snapshot: DetailsViewSnapshot, title: String, rateTitle: String)
}

final class DetailsViewModel: DetailsViewModelType {

    private let movie: MovieViewModel

    weak var delegate: DetailsViewModelDelegate?

    init(movie: MovieViewModel) {
        self.movie = movie
    }

    func didLoad() {
        var snapshot = DetailsViewSnapshot()
        snapshot.appendSections([DetailsSection.details])
        snapshot.appendItems([
            .image(imagePath: movie.posterImagePath),
            .text(title: "Overview",
                  description: movie.overview)
        ])
        if let movieCast = movie.cast {
            snapshot.appendItems([.text(title: "Cast", description: movieCast)])
        }

        delegate?.updateWithSnapshot(snapshot: snapshot, title: movie.title, rateTitle: "\(movie.rate) 🏆")
    }
}
