import UIKit

enum StoryboardName: String {
    case login = "Login"
    case projects = "Projects"
}

protocol Storyboardable {
    static var storyboardIdentifier: String { get }
}

extension Storyboardable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: StoryboardName) -> Self {
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}
