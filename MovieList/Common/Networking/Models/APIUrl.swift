import Foundation

enum APIUrl {
    case baseUrl
    case imageUrl
    
    var url: String {
        switch self {
        case .baseUrl:
            return "https://api.themoviedb.org/3"
        case .imageUrl:
            return "https://image.tmdb.org/t/p/w500"
        }
    }
}
