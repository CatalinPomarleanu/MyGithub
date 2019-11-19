import UIKit

extension UITableView {

    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseId)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(at indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell
            else {
                fatalError("Fatal error for cell at \(indexPath)")
        }
        
        return cell
    }
}
