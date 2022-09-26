import Foundation

final class Loader {
    typealias LoaderResult<Mapper: ResponseMapperType> = Swift.Result<Mapper.ResponseResult, APIError>
    typealias LoaderResultCompletion<Mapper: ResponseMapperType> = (LoaderResult<Mapper>) -> Void

    func performRequest<Request: BaseRouter,
                        Mapper: ResponseMapperType,
                        ErrorHandler: ServerErrorHandlerType>(request: Request,
                                                              mapper: Mapper,
                                                              errorHandler: ErrorHandler,
                                                              completion: @escaping LoaderResultCompletion<Mapper>) {
        NetworkClient(
            errorHanlder: errorHandler,
            requestManager: request.requestManager
        )
        .performRequest(request) { (result) in
            self.handleResponse(result, mapper: mapper, completion: completion)
        }
    }
}

private extension Loader {
    func handleResponse<Mapper: ResponseMapperType>(_ result: NetworkClientResult,
                                                    mapper: Mapper,
                                                    completion: @escaping LoaderResultCompletion<Mapper>) {
        switch result {
        case .success(let object):
            mapper.mapResponse(object) { result in
                switch result {
                case .success(let mappedResponse):
                    completion(.success(mappedResponse))
                case .failure:
                    completion(.failure(APIError.objectSerialization))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
