import Foundation

protocol RequestManagerType {
    func performRequest<T: BaseRouter>(request: T, completion: @escaping (ResponseResultModel) -> Void )
}
