import Foundation

typealias ResponseMapperCompletion<T> = (Swift.Result<T, APIError>) -> ()

protocol ResponseMapperType {
    associatedtype ResponseResult
    
    func mapResponse(_ dataResponse: Data, completion: @escaping ResponseMapperCompletion<ResponseResult>)
}
