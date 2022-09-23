import Foundation

enum ResourcesRouter {
    case poster(imagePath: String)
}

extension ResourcesRouter: BaseRouter {
    var queryParameters: [String : String] {
        [:]
    }
    
    var isRequiresAPIKey: Bool {
        false
    }
    var body: Codable? {
        nil
    }
    
    var baseUrl: String {
        APIUrl.imageUrl.url
    }
    
    var requestPath: String {
        switch self {
        case .poster(let imagePath):
            return imagePath
        }
    }
    
    var requestMethod: HTTPMethod {
        .get
    }
    
    var requestManager: RequestManagerType {
        URLSessionRequestManager()
    }
}
