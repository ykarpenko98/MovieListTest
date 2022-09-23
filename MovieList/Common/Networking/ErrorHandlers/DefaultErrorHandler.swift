import Foundation

final class DefaultErrorHandler: ServerErrorHandlerType {
    func handleErrorFrom(response: Data, statusCode: Int) -> APIError {
        return .server(details: "Uncategorized Error")
    }
}
