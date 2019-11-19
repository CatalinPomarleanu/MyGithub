import UIKit
import RxSwift

class FlowController {
    
    // MARK: - Parameters
    
    var window: UIWindow?
    private let disposeBag = DisposeBag()
    
    // MARK: - Shared Instance
    
    static let shared = FlowController()
    private init() {}
    
    // MARK: - Public Methods
    
    func loadRootController(in window: UIWindow?) {
        self.window = window
        loadLoginScreen()
    }
    
    func loadProjectsScreen() {
        let projectsVC = ProjectsViewController.initFromStoryboard(name: .projects)
        let viewModel = ProjectsViewModel(projectsService: ProjectsService(), currentUser: AppContext.shared.currentUser)
        projectsVC.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: projectsVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func logout() {
        loadLoginScreen()
    }
    
    // MARK: - Private Methods
    
    private func loadLoginScreen() {
        let loginVC = LoginViewController.initFromStoryboard(name: .login)
        let viewModel = LoginViewModel(LoginService())
        loginVC.viewModel = viewModel
        
        viewModel.onLoginSuccessSubject.subscribe { [weak self] _ in
            self?.loadProjectsScreen()
        }.disposed(by: disposeBag)
        
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
}
