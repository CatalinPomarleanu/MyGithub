import Foundation
import RxSwift

enum LoginServicePath: String {
    case login = "/user"
}

protocol LoginServiceProtocol {
    func signIn(with credentials: UserCredentials) -> Observable<User>
}

class LoginService: LoginServiceProtocol {
    
    func signIn(with credentials: UserCredentials) -> Observable<User> {
        return Observable.create { observer in
            let loginString = "\(credentials.username):\(credentials.password)"
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            RequestService.doGet(path: LoginServicePath.login.rawValue,
                                 queryItems: nil,
                                 headers: ["Authorization" : "Basic \(base64LoginString)"]) { (result: Result<User, NetworkError>) in
                                    switch result {
                                    case .success(let user):
                                        observer.onNext(user)
                                    case .failure(let error):
                                        observer.onError(error)
                                    }
            }
            
            return Disposables.create()
        }
    }
}
