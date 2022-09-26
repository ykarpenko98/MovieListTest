import Foundation
import UIKit

extension UITableView {

    func register<T: UITableViewCell>(class identifier: T.Type) {
        let identifierString = String(describing: identifier)
        register(T.self, forCellReuseIdentifier: identifierString)
    }

    func dequeue<T: UITableViewCell>(reusable identifier: T.Type) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withIdentifier: identifierString) as! T
    }

    func dequeue<T: UITableViewCell>(reusable identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withIdentifier: identifierString, for: indexPath) as! T
    }
}
