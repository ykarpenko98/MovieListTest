import Foundation
import UIKit

final class ImageResponseMapper: ResponseMapperType {
    typealias ResponseResult = UIImage

    func mapResponse(_ dataResponse: Data, completion: @escaping ResponseMapperCompletion<ResponseResult>) {
        if let image = UIImage(data: dataResponse) {
            completion(.success(image))
        } else {
            completion(.failure(.objectSerialization))
        }
    }
}
