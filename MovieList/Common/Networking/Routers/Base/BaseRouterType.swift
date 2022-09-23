import Foundation
protocol BaseRouter {
    var isRequiresAPIKey: Bool { get }
    var baseUrl: String { get }
    var requestPath: String { get }
    var requestMethod: HTTPMethod { get }
    var requestHeaders: [String: String]? { get }
    var body: Codable? { get }
    var requestManager: RequestManagerType { get }
    var queryParameters: [String: String] { get }
}

// MARK: - Default Implementation

extension BaseRouter {
    var requestHeaders: [String : String]? {
        let header =       [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return header
    }
}

// MARK: - BaseRouter + URLSession

extension BaseRouter {
    var apiKey: String {
        return "815b63b537c380370911f6cb083031b0"
    }
    
    var asURLRequest: URLRequest {
        var queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        if isRequiresAPIKey {
            queryItems.append(.init(name: "api_key", value: apiKey))
        }
        var urlComponents = URLComponents(string: baseUrl + requestPath)
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = requestMethod.rawValue
        if  let body = body,
            let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.httpBody = httpBody
        }
        requestHeaders?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
}
