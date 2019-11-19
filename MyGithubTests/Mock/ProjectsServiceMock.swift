import Foundation
import RxSwift

class ProjectsServiceMock: ProjectsServiceProtocol {
    func fetchProjects(for user: User) -> Observable<[Project]> {
        return Observable.create { observer in
            guard user.userName == MOCK_USERNAME
                else {
                    observer.onError(NetworkError.unauthorized)
                    return Disposables.create()
            }
            
            observer.onNext(MOCK_PROJECTS)
            return Disposables.create()
        }
    }
}
