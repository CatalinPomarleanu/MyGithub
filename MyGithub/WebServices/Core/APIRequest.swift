import Foundation
import Alamofire

struct APIRequest: API {
    var path: String
    var method: HTTPMethod
    var queryItems: [String : String]?
    var body: Parameters?
    var headers: HTTPHeaders?
}
