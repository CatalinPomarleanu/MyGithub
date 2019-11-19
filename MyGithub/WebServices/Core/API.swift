import Foundation
import Alamofire

let API_BASE_URL = "https://api.github.com"

protocol API {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String]? { get }
    var body: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

extension API {
    
    func send(completion: @escaping (_ data: Data?, _ error: NetworkError?) -> Void) {
        guard let url = requestUrl()
            else {
                completion(nil, .invalidRequest)
                return
        }
        
        AF.request(url, method: method, parameters: body, headers: updatedHeaders())
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                guard let reponseData = response.data else {
                    completion(nil, .invalidCredentials)
                    return
                }
                completion(reponseData, nil)
        }
    }
    
    private func requestUrl() -> URL? {
        guard let baseUrl = URL(string: API_BASE_URL),
            var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
            else {
                return nil
        }
        
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = getQueryItems()
        
        return urlComponents.url
    }
    
    private func getQueryItems() -> [URLQueryItem]? {
        guard let queryItems = queryItems else { return nil }
        var result = [URLQueryItem]()
        for (key, value) in queryItems {
            result.append(URLQueryItem(name: key, value: value))
        }
        return result
    }
    
    private func updatedHeaders() -> HTTPHeaders {
        var updatedHeaders = headers ?? []
        
        let credentials = AuthenticatedContext.userAndPassword()
        if let username = credentials.user,
            let password = credentials.password,
            let loginData = "\(username):\(password)".data(using: String.Encoding.utf8) {
            
            updatedHeaders["Authorization"] = "Basic \(loginData.base64EncodedString())"
        }
        
        return updatedHeaders
    }
}
