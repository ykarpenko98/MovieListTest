import Foundation

@testable import MovieList

class Helper {

    func makeMoviePageModel() -> MoviePageModel {
        let path = Bundle(for: ListViewModelTests.self).path(forResource: "MoviePageModel", ofType: "json")!
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
        return try! JSONDecoder().decode(MoviePageModel.self, from: jsonData)
    }

    func makeGenresListModel() -> GenresListModel {
        let path = Bundle(for: ListViewModelTests.self).path(forResource: "GenresList", ofType: "json")!
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
        return try! JSONDecoder().decode(GenresListModel.self, from: jsonData)
    }

    func makeMovieCreditsList() -> MovieCreditsModel {
        let path = Bundle(for: ListViewModelTests.self).path(forResource: "MovieCredits", ofType: "json")!
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path))
        return try! JSONDecoder().decode(MovieCreditsModel.self, from: jsonData)
    }
}
