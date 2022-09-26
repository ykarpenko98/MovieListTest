import Foundation

final class MovieFactory {
    
    private let movies: [MovieModel]
    private let genres: [GenreModel]
    
    init(movies: [MovieModel], genres: [GenreModel]) {
        self.movies = movies
        self.genres = genres
    }
    
    func make() -> [MovieViewModel] {
        var result = [MovieViewModel]()
        movies.forEach { movieModel in
            var movieGenre = genres
                .filter { movieModel.genreIds.contains($0.id) }
                .map { $0.name.uppercased() }
                .reduce("") { partialResult, element in
                    return "\(partialResult)\(element), "
                }
            if !movieGenre.isEmpty {
                movieGenre.removeLast(2)
            }
            
            let movie = MovieViewModel(id: movieModel.id,
                              title: movieModel.title,
                              genres: movieGenre,
                              rate: movieModel.voteAverage,
                              overview: movieModel.overview,
                              posterImagePath: movieModel.posterPath)
            result.append(movie)
        }
        return result
    }
}
