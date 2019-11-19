import XCTest
import RxSwift
import RxCocoa

class LoginViewModelTests: XCTestCase {

    var loginViewModel: LoginViewModel!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        loginViewModel = LoginViewModel(LoginServiceMock())
    }
    
    func testLoginSuccess() {
        let expectation = XCTestExpectation()
        
        // When setting correct credentials
        loginViewModel.username.accept(MOCK_USERNAME)
        loginViewModel.password.accept(MOCK_PASSWORD)
        
        // Then set observers
        loginViewModel.onLoginSuccessSubject.subscribe { _ in
            XCTAssert(true)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        loginViewModel.errorsSubject
            .subscribe(onNext: { error in
                XCTFail("Login failed")
                expectation.fulfill()
            })
        .disposed(by: disposeBag)
        
        // Then do login
        loginViewModel.didTapSignIn.onNext(())
        
        // Test login succeeds
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoginFailed() {
        let expectation = XCTestExpectation()
        
        // When setting wrong credentials
        loginViewModel.username.accept(MOCK_USERNAME)
        loginViewModel.password.accept("WRONG_MOCK_PASSWORD")
        
        // Then set observers
        loginViewModel.onLoginSuccessSubject.subscribe { _ in
            XCTFail("Login should fail")
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        loginViewModel.errorsSubject
            .subscribe(onNext: { error in
                XCTAssert(true)
                expectation.fulfill()
            })
        .disposed(by: disposeBag)
        
        // Then do login
        loginViewModel.didTapSignIn.onNext(())
        
        // Test login fails
        wait(for: [expectation], timeout: 1)
    }
}
