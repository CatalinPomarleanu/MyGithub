import UIKit

struct ProjectCellRepresentation {
    
    // MARK: - Parameters

    let title: String
    let description: String
    let stars: Int
    
    // MARK: - Public Methods
    
    func configure(_ cell: ProjectTableViewCell) {
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.starsLabel.text = "Stars: \(stars)"
        
        cell.descriptionLabel.isHidden = description.isEmpty
    }
}

class ProjectTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
