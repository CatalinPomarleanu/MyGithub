import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, Storyboardable {
    
    // MARK: Parameters
    
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: - Helpers
    
    private func bindViewModel() {
        guard let viewModel = viewModel
            else {
                return
        }
        usernameTextField.rx.text.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTextField.rx.text.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }
            .bind(to: signInButton.rx.isEnabled )
            .disposed(by: disposeBag)
        
        signInButton.rx.tap.asObservable()
        .subscribe(viewModel.didTapSignIn)
        .disposed(by: disposeBag)
        
        viewModel.errorsSubject
            .subscribe(onNext: { [weak self] error in
                self?.presentAlert(withTitle: "Error", message: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
}
