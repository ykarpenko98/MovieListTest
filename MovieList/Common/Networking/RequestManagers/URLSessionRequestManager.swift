import Foundation

final class URLSessionRequestManager: RequestManagerType {
    func performRequest<T: BaseRouter>(request: T, completion: @escaping (ResponseResultModel) -> Void) {
        URLSession.shared.dataTask(with: request.asURLRequest) { (data, response, error) in
            completion(ResponseResultModel(responseData: data,
                                           response: response as? HTTPURLResponse,
                                           error: error)
            )
        }
        .resume()
    }
}
