import UIKit

protocol Reusable {}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        String(describing: self)
    }
}
