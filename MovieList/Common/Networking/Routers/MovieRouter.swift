import Foundation

enum MovieRouter {
    case getGenres
    case getMovieList(page: Int)
    case getMovieSearchList(page: Int, searchString: String)
    case getMovieCredits(id: Int)
}

extension MovieRouter: BaseRouter {
    var body: Codable? {
        nil
    }

    var isRequiresAPIKey: Bool {
        true
    }

    var requestManager: RequestManagerType {
        URLSessionRequestManager()
    }

    var baseUrl: String {
        APIUrl.baseUrl.url
    }

    var requestPath: String {
        switch self {
        case .getMovieList:
            return "/discover/movie"
        case .getMovieCredits(let id):
            return "/movie/\(id)/credits"
        case .getGenres:
            return "/genre/movie/list"
        case .getMovieSearchList:
            return "/search/movie"
        }
    }

    var queryParameters: [String: String] {
        switch self {
        case .getGenres:
            return [:]
        case .getMovieList(let page):
            return ["page": String(page)]
        case .getMovieSearchList(let page, let searchString):
            return ["page": String(page), "query": searchString]
        case .getMovieCredits:
            return [:]
        }
    }

    var requestMethod: HTTPMethod {
        .get
    }
}
