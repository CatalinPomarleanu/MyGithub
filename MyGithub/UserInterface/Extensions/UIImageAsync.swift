import UIKit
import Alamofire

fileprivate func downloadImage(at urlString: String?,
                               placeholder: UIImage,
                               completion: @escaping (_ image: UIImage) -> Void) {
    guard let imageUrlString = urlString,
        let imageUrl = URL(string: imageUrlString)
        else {
            completion(placeholder)
            return
    }
    
    AF.download(imageUrl).responseData { (response) in
        guard let data = response.value, let image = UIImage(data: data, scale: 1)?.withRenderingMode(.alwaysOriginal)
            else {
                completion(placeholder)
                return
        }
        completion(image)
    }
}

extension UIBarButtonItem {
    
    func setRemoteImage(at urlString: String?, placeholder: UIImage) {
        downloadImage(at: urlString, placeholder: placeholder) { [weak self] resultImage in
            DispatchQueue.main.async {
                self?.image = resultImage
            }
        }
    }
}
