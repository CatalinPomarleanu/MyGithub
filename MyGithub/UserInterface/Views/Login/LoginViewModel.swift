import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    
    // MARK: - Parameters

    var username = BehaviorRelay<String?>(value: "")
    var password = BehaviorRelay<String?>(value: "")
    
    let didTapSignIn = PublishSubject<Void>()
    let errorsSubject = PublishSubject<Error>()
    
    let onLoginSuccessSubject = PublishSubject<User>()
    
    private let disposeBag = DisposeBag()
    
    private var credentialsObservable: Observable<UserCredentials> {
        return Observable.combineLatest(username.asObservable(), password.asObservable()) { (username, password) in
            return UserCredentials(username: username ?? "", password: password ?? "")
        }
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(username.asObservable(), password.asObservable()) { (username, password) in
            return !(username ?? "").isEmpty && !(password ?? "").isEmpty
        }
    }
    
    // MARK: - Initialize
    
    init(_ loginService: LoginServiceProtocol) {
        super.init()
        
        didTapSignIn
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { credentials in
                return loginService.signIn(with: credentials).materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let user):
                    self?.saveCredentials()
                    AppContext.shared.currentUser = user
                    self?.onLoginSuccessSubject.onNext(user)
                case .error(let error):
                    self?.errorsSubject.onNext(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func saveCredentials() {
        AuthenticatedContext.setUser(user: username.value ?? "", password: password.value ?? "")
    }
}
