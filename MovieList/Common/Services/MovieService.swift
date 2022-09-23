//
//  MovieService.swift
//  MovieList
//
//  Created by anduser on 22.09.2022.
//

import Foundation

protocol MovieServiceType {
    func getMovieList(page: Int, completion: @escaping (Result<MoviePageModel, APIError>) -> ())
    
    func getMovieGenres(completion: @escaping (Result<GenresListModel, APIError>) -> ())
    
    func getMovieCredits(movieId: Int, completion: @escaping (Result<MovieCreditsModel, APIError>) -> ())
    
    func getMovieSearchList(page: Int, searchString: String, completion: @escaping (Result<MoviePageModel, APIError>) -> ())
}

final class MovieService: MovieServiceType {
    
    private let loader = Loader()
    
    func getMovieList(page: Int, completion: @escaping (Result<MoviePageModel, APIError>) -> ()) {
        let router = MovieRouter.getMovieList(page: page)
        let mapper = DecodableResponseMapper<MoviePageModel>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getMovieGenres(completion: @escaping (Result<GenresListModel, APIError>) -> ()) {
        let router = MovieRouter.getGenres
        let mapper = DecodableResponseMapper<GenresListModel>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getMovieCredits(movieId: Int, completion: @escaping (Result<MovieCreditsModel, APIError>) -> ()) {
        let router = MovieRouter.getMovieCredits(id: movieId)
        let mapper = DecodableResponseMapper<MovieCreditsModel>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getMovieSearchList(page: Int, searchString: String, completion: @escaping (Result<MoviePageModel, APIError>) -> ()) {
        let router = MovieRouter.getMovieSearchList(page: page, searchString: searchString)
        let mapper = DecodableResponseMapper<MoviePageModel>()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
