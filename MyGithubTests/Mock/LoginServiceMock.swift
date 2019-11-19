import Foundation
import RxSwift

class LoginServiceMock: LoginServiceProtocol {
    func signIn(with credentials: UserCredentials) -> Observable<User> {
        return Observable.create { observer in
            guard credentials.username == MOCK_USERNAME,
            credentials.password == MOCK_PASSWORD
                else {
                    observer.onError(NetworkError.invalidCredentials)
                    return Disposables.create()
            }
            
            observer.onNext(MOCK_USER)
            return Disposables.create()
        }
    }
}
