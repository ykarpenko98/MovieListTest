import Foundation

typealias NetworkClientResult = Swift.Result<Data, APIError>
typealias NetworkClientCompletion = ((NetworkClientResult) -> ())

protocol NetworkClientType {
    func performRequest<T: BaseRouter>(_ request: T,
                                       completion: NetworkClientCompletion?)
}

// MARK: - Error hanlding Layer

final class NetworkClient: NetworkClientType {
    
    private let serverErrorHandler: ServerErrorHandlerType
    private var requestManager: RequestManagerType
    init(errorHanlder: ServerErrorHandlerType, requestManager: RequestManagerType) {
        self.serverErrorHandler = errorHanlder
        self.requestManager = requestManager
    }
    
    func performRequest<T>(_ request: T, completion: NetworkClientCompletion?) where T : BaseRouter {
        requestManager.performRequest(request: request) { (response) in
            completion?(self.handleError(response))
        }
    }
}

private extension NetworkClient {
    
    func handleError(_ response: ResponseResultModel) -> NetworkClientResult {
        let statusCode = response.response?.statusCode
        switch (response.responseData, response.error, statusCode) {
        case (let data?, nil, let statusCode?) where (400...500).contains(statusCode):
            let handledError = serverErrorHandler.handleErrorFrom(response: data, statusCode: statusCode)
            return .failure(handledError)
        case (let data?, nil, _):
            return .success(data)
        case ( _, let error?, _):
            return .failure(wrapError(error))
        default:
            return .failure(APIError.network(description: "UNRECOGNIZED ERROR"))
        }
    }

    func wrapError(_ error: Error) -> APIError {
        if (error as NSError).code == NSURLErrorCancelled {
            return APIError.cancelled
        }
        return APIError.network(description: error.localizedDescription)
    }
}
