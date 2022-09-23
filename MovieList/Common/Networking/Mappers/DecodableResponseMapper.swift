import Foundation

final class DecodableResponseMapper<T: Decodable>: ResponseMapperType {
    
    typealias ResponseResult = T
    
    func mapResponse(_ dataResponse: Data, completion: @escaping ResponseMapperCompletion<ResponseResult>) {
        do {
            let models = try JSONDecoder().decode(ResponseResult.self, from: dataResponse)
            completion(.success(models))
        } catch {
            completion(.failure(.objectSerialization))
        }
    }
}
