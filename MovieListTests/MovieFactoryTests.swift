// swiftlint:disable line_length
import XCTest
@testable import MovieList

class MovieFactoryTests: XCTestCase {

    func test_MovieFactory_ValidParse() {
        let movie = Helper().makeMoviePageModel().movies[0]
        let genres = Helper().makeGenresListModel().genres
        let factory = MovieFactory(movies: [movie], genres: genres)

        let models = factory.make()

        XCTAssertEqual(models.count, 1)
        XCTAssertEqual(models, [
            MovieViewModel(id: 755566,
                           title: "Day Shift",
                           genres: "ACTION, COMEDY, FANTASY, HORROR",
                           rate: 6.9,
                           overview: "An LA vampire hunter has a week to come up with the cash to pay for his kid\'s tuition and braces. Trying to make a living these days just might kill him.",
                           posterImagePath: "/bI7lGR5HuYlENlp11brKUAaPHuO.jpg",
                           cast: nil)
        ])
    }
}
