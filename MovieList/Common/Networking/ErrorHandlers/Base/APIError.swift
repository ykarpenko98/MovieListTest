import Foundation

enum APIError: CustomStringConvertible, CustomDebugStringConvertible, Error {
    case server(details: String)
    case serverUnwrapped(details: String)
    case network(description: String)
    case objectSerialization
    case uploadEncoding(reason: String?)
    case cancelled

    var description: String {
        switch self {
        case .server(let details):
            return "Error: \(details.description)"
        case .serverUnwrapped(let details):
            return "Error: \(details.description)"
        case .network(let details):
            return "Network Error:\(details)"
        case .objectSerialization:
            return "Server Error: Bad Response Format"
        case .uploadEncoding(let reason):
            return "Upload Encoding Error: \(reason ?? "")"
        case .cancelled:
            return "Cancelled"
        }
    }

    var debugDescription: String { description }
}
