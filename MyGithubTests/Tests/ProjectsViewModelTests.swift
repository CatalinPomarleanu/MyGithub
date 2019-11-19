import XCTest
import Foundation
import RxSwift

class ProjectsViewModelTests: XCTestCase {

    var viewModel: ProjectsViewModel!
    var disposeBag = DisposeBag()
    
    func testProjectsDownloaded() {
        let expectation = XCTestExpectation()
        
        // When being logged with a correct user
        viewModel = ProjectsViewModel(projectsService: ProjectsServiceMock(), currentUser: MOCK_USER)
        
        // Then subscribe for projects representations
        viewModel.sections.subscribe(onNext: { (sections) in
            // Test that the correct number of projects have been downloaded
            XCTAssertTrue(sections.first?.items.count == MOCK_PROJECTS.count)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testUnauthorized() {
        let expectation = XCTestExpectation()
        let projectsService = ProjectsServiceMock()
        
        // When being logged with a wrong user
        viewModel = ProjectsViewModel(projectsService: projectsService, currentUser: MOCK_WRONG_USER)
        
        // Then observe for errors
        viewModel.errorsSubject
            .subscribe(onNext: { error in
                // Test that the user in unauthorized
                XCTAssertTrue((error as? NetworkError) == NetworkError.unauthorized)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Then try to fetch projects
        viewModel.fetchProjects(projectsService: projectsService)
        
        wait(for: [expectation], timeout: 1)
    }
}
