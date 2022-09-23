import Foundation

protocol ServerErrorHandlerType {
    func handleErrorFrom(response: Data, statusCode: Int) -> APIError
}
