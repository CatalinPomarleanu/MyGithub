import UIKit

extension UIViewController {

    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        self.present(alertController, animated: true)
    }
}
