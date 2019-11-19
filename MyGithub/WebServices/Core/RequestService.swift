import Foundation
import Alamofire

class RequestService {
    
    static func doGet<T:Decodable>(path: String,
                                   queryItems: [String : String]?,
                                   headers: HTTPHeaders?,
                                   completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = APIRequest(path: path,
                                 method: .get,
                                 queryItems: queryItems,
                                 body: nil,
                                 headers: headers)
        doRequest(request, completion: completion)
    }
    
    static func doPost<T:Decodable>(path: String,
                                   body: Parameters?,
                                   headers: HTTPHeaders?,
                                   completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = APIRequest(path: path,
                                 method: .post,
                                 queryItems: nil,
                                 body: body,
                                 headers: headers)
        doRequest(request, completion: completion)
    }
}

fileprivate extension RequestService {
    
    static func doRequest<T: Decodable>(_ request: API, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request.send() { (data, error) in
            guard error == nil, let data = data
                else {
                    completion(.failure(.invalidRequest))
                    return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }
}
