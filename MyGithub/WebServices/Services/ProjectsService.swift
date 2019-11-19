import Foundation
import RxSwift

enum ProjectsServicePath {
    case projects(username: String)
    
    var fullPath: String {
        switch self {
        case .projects(let username):
            return "/users/\(username)/repos"
        }
    }
}

protocol ProjectsServiceProtocol {
    func fetchProjects(for user: User) -> Observable<[Project]>
}

class ProjectsService: ProjectsServiceProtocol {
    
    func fetchProjects(for user: User) -> Observable<[Project]> {
        return Observable.create { observer in
            RequestService.doGet(path: ProjectsServicePath.projects(username: user.userName).fullPath,
                                 queryItems: nil,
                                 headers: ["type" : "all"]) { (result: Result<[Project], NetworkError>) in
                                    switch result {
                                    case .success(let projects):
                                        observer.onNext(projects)
                                    case .failure(let error):
                                        observer.onError(error)
                                    }
            }
            
            return Disposables.create()
        }
    }
    

}
