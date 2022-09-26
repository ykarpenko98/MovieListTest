import Foundation
import UIKit

protocol ResourceServiceType {
    func getImagePoster(imagePath: String, completion: @escaping (Result<UIImage, APIError>) -> Void)
}
final class ResourceService {

    private let loader = Loader()

    func getImagePoster(imagePath: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        let router = ResourcesRouter.poster(imagePath: imagePath)
        let mapper = ImageResponseMapper()
        let errorHandler = DefaultErrorHandler()
        loader.performRequest(request: router, mapper: mapper, errorHandler: errorHandler) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
