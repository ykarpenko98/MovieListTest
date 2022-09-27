// swiftlint:disable line_length
import XCTest
@testable import MovieList

class ListViewModelTests: XCTestCase {

    private var sut: ListViewModel!
    private var outputDelegate: SpyListViewModelDelegate!
    private var navigationDelegate: SpyListViewModelNavigationDelegate!
    private var movieService: MockMovieService!

    override func setUpWithError() throws {
        outputDelegate = SpyListViewModelDelegate()
        navigationDelegate = SpyListViewModelNavigationDelegate()
        movieService = MockMovieService()
        sut = ListViewModel(movieService: movieService)
        sut.delegate = outputDelegate
        sut.navigationDelegate = navigationDelegate
    }

    func test_MovieListViewModel_InitialLoad() throws {
        sut.didLoad()

        XCTAssertEqual(outputDelegate.displayErrorArr.count, 0)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr.count, 1)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr[0].numberOfItems, 20)
        XCTAssertEqual(outputDelegate.setLoadingStateArr.count, 4)
    }

    func test_MovieListViewModel_LoadNextPage() {
        sut.didLoad()
        sut.loadNextPage()

        XCTAssertEqual(outputDelegate.displayErrorArr.count, 0)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr.count, 2)
        XCTAssertEqual(outputDelegate.setLoadingStateArr.count, 6)
    }

    func test_MovieListViewModel_StartSearch() {
        sut.didLoad()
        sut.search(string: "21")

        XCTAssertEqual(outputDelegate.displayErrorArr.count, 0)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr.count, 2)
        XCTAssertEqual(outputDelegate.setLoadingStateArr.count, 6)
    }

    func test_MovieListViewModel_didSelectItem() {
        sut.didLoad()
        sut.didSelectCell(at: IndexPath(row: 2, section: 0))

        XCTAssertEqual(navigationDelegate.showDetailsMovieArr, [
            MovieViewModel(id: 576925,
                           title: "My Sweet Monster",
                           genres: "ADVENTURE, ANIMATION, FAMILY",
                           rate: 6.0,
                           overview: "A scandal in the royal family: the wayward princess Barbara escaped from the palace and went through the forest in search of a handsome prince. However, instead of the cherished meeting with her beloved, she is captured by Buka, the most dangerous robber of the kingdom. But it quickly becomes clear that the brisk princess is ready to turn Buka\'s life into a nightmare, just to reach her goal. So the restless Varvara begins to establish her own order in the forest.",
                           posterImagePath: "/xIbEHAqwK5N7PJJYmbwmxuvC7fL.jpg",
                           cast: "Edoardo Pesce, Alessandro Roja, Alessandra Mastronardi, Christian De Sica, Francesco Bruni, Massimiliano Rossi, Michael Schermi, Gabriele Cristini, Christian Monaldi, Mauro Aversano, Nana Funabiki, Carlo Valli")
        ])
    }

    func test_MovieListViewModel_EmptyResult() {
        movieService.getMovieListMock = .success(.init(page: 1, movies: [], totalPages: 0, totalResults: 0))
        sut.didLoad()
        XCTAssertEqual(outputDelegate.displayErrorArr.count, 0)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr.count, 1)
        XCTAssertEqual(outputDelegate.updateWithSnapshotArr[0].itemIdentifiers, [.empty])
        XCTAssertEqual(outputDelegate.setLoadingStateArr.count, 4)
    }
}

class MockMovieService: MovieServiceType {

    var getMovieListMock: Result<MoviePageModel, APIError> = .success(Helper().makeMoviePageModel())
    func getMovieList(page: Int, completion: @escaping (Result<MoviePageModel, APIError>) -> Void) {
        completion(getMovieListMock)
    }

    var getMovieGenresMock: Result<GenresListModel, APIError> = .success(Helper().makeGenresListModel())
    func getMovieGenres(completion: @escaping (Result<GenresListModel, APIError>) -> Void) {
        completion(getMovieGenresMock)
    }

    var getMovieCreditsMock: Result<MovieCreditsModel, APIError> = .success(Helper().makeMovieCreditsList())
    func getMovieCredits(movieId: Int, completion: @escaping (Result<MovieCreditsModel, APIError>) -> Void) {
        completion(getMovieCreditsMock)
    }
    var getMovieSearchListMock: Result<MoviePageModel, APIError> = .success(Helper().makeMoviePageModel())
    func getMovieSearchList(page: Int, searchString: String, completion: @escaping (Result<MoviePageModel, APIError>) -> Void) {
        completion(getMovieSearchListMock)
    }
}

class SpyListViewModelDelegate: ListViewModelDelegate {

    private(set) var setLoadingStateArr: [Bool] = []
    private(set) var updateWithSnapshotArr: [ListViewSnapshot] = []
    private(set) var displayErrorArr: [String] = []

    func setLoadingState(_ isLoading: Bool) {
        setLoadingStateArr.append(isLoading)
    }

    func updateWithSnapshot(_ snapshot: ListViewSnapshot) {
        updateWithSnapshotArr.append(snapshot)
    }

    func displayError(message: String) {
        displayErrorArr.append(message)
    }
}

class SpyListViewModelNavigationDelegate: ListViewModelNavigationDelegate {

    private(set) var showDetailsMovieArr: [MovieViewModel] = []

    func showDetails(for movie: MovieViewModel) {
        showDetailsMovieArr.append(movie)
    }
}
