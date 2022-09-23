import Foundation
import UIKit

typealias ListViewSnapshot = NSDiffableDataSourceSnapshot<ListSection, ListSectionItem>

enum ListSection: String, CaseIterable {
    case list
}

enum ListSectionItem: Hashable {
    case film(movie: Movie)
}

protocol ListViewModelType {
    func didLoad()
    func didSelectCell(at indexPath: IndexPath)
    func search(string: String)
    func discardSearch()
    func loadNextPage()
}

protocol ListViewModelDelegate: AnyObject {
    func setLoadingState(_ isLoading: Bool)
    func updateWithSnapshot(_ snapshot: ListViewSnapshot)
    func displayError(message: String)
}

protocol ListViewModelNavigationDelegate: AnyObject {
    func showDetails(for movie: Movie)
}

final class ListViewModel: ListViewModelType {
    
    private let movieService: MovieServiceType
    private var genres: [GenreModel] = []
    private var snapshot: ListViewSnapshot!
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var movies: [Movie] = []
    private var searchText: String = .init()
    
    weak var delegate: ListViewModelDelegate?
    weak var navigationDelegate: ListViewModelNavigationDelegate?
    
    init(movieService: MovieServiceType) {
        self.movieService = movieService
    }
    
    func didLoad() {
        loadGenresAndFirstPage()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let items = snapshot.itemIdentifiers(inSection: .list)
        let selectedItem = items[indexPath.row]
        guard case var .film(movie) = selectedItem else { return }
        delegate?.setLoadingState(true)
        movieService.getMovieCredits(movieId: movie.id) { [weak self] result in
            self?.delegate?.setLoadingState(false)
            switch result {
            case .success(let movieCreds):
                movie.cast = movieCreds.castDescription
                self?.navigationDelegate?.showDetails(for: movie)
            case .failure(let error):
                self?.delegate?.displayError(message: error.description)
            }
        }
    }
    
    func loadNextPage() {
        guard !isLoading else {
            return
        }
        isLoading = true
        currentPage += 1
        if searchText.isEmpty {
            loadNextMoviesPage()
        } else {
            loadNextMoviesSearchPage()
        }
    }
    
    func search(string: String) {
        searchText = string
        reloadMovies()
    }
    
    func discardSearch() {
        searchText = .init()
        reloadMovies()
    }
    
    private func reloadMovies() {
        snapshot = nil
        currentPage = 1
        loadNextPage()
    }
    
    private func loadNextMoviesSearchPage() {
        delegate?.setLoadingState(true)
        movieService.getMovieSearchList(page: currentPage, searchString: searchText) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.makeSnapshotAndApply(responseMovies: response.movies)
                case .failure(let error):
                    self?.delegate?.displayError(message: error.description)
                }
                self?.delegate?.setLoadingState(false)
                self?.isLoading = false
        }
    }
    
    private func loadNextMoviesPage() {
        delegate?.setLoadingState(true)
        movieService.getMovieList(page: currentPage) { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.makeSnapshotAndApply(responseMovies: response.movies)
            case .failure(let error):
                self?.delegate?.displayError(message: error.description)
            }
            self?.delegate?.setLoadingState(false)
            self?.isLoading = false
        }
    }
    
    private func loadGenresAndFirstPage() {
        delegate?.setLoadingState(true)
        movieService.getMovieGenres { [weak self] result in
            self?.delegate?.setLoadingState(false)
            switch result {
            case .success(let genreModel):
                self?.genres = genreModel.genres
                self?.reloadMovies()
            case .failure(let error):
                self?.delegate?.displayError(message: error.description)
            }
        }
    }
    
    private func makeSnapshotAndApply(responseMovies: [MovieModel]) {
        if snapshot == nil {
            var snapshot = ListViewSnapshot()
            snapshot.appendSections([.list])
            self.snapshot = snapshot
        }
        let movies = MovieFactory(movies: responseMovies, genres: genres).make()
        
        snapshot.appendItems(movies.map { .film(movie: $0) }, toSection: .list)
        
        delegate?.updateWithSnapshot(snapshot)
    }
}


