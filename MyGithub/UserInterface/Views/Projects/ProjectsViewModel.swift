import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum SortingRule: Int {
    case byName
    case byStars
}

struct ProjectsSection {
    var items: [ProjectCellRepresentation]
}

extension ProjectsSection: SectionModelType {
    typealias Item = ProjectCellRepresentation
    
    init(original: ProjectsSection, items: [ProjectCellRepresentation]) {
        self = original
        self.items = items
    }
}

class ProjectsViewModel {
    
    // MARK: - Parameters
    var currentUser: User?
    private var projects: [Project]
    private let disposeBag = DisposeBag()
    let errorsSubject = PublishSubject<Error>()
    
    lazy var sortingRule: BehaviorRelay<Int> = BehaviorRelay<Int>(value: SortingRule.byName.rawValue)
    lazy var sections: BehaviorRelay<[ProjectsSection]> = BehaviorRelay<[ProjectsSection]>(value: sectionsValue)
    
    private var sectionsValue: [ProjectsSection] {
        var cellsRepresentations = projects.map({ ProjectCellRepresentation(title: $0.name,
                                                                            description: $0.description,
                                                                            stars: $0.stars) })
        
        if let sortingRule = SortingRule(rawValue: self.sortingRule.value) {
            cellsRepresentations.sort { (representation1, representation2) -> Bool in
                switch sortingRule {
                case .byName:
                    return representation1.title > representation2.title
                case .byStars:
                    return representation1.stars > representation2.stars
                }
            }
        }
        
        return [ProjectsSection(items: cellsRepresentations)]
    }
    
    // MARK: - Initializer
    
    init(projectsService: ProjectsServiceProtocol, currentUser: User?) {
        projects = []
        self.currentUser = currentUser
        
        guard let _ = currentUser
            else {
                logout()
                return
        }
        
        fetchProjects(projectsService: projectsService)
    }
    
    // MARK: - Public Methods
    
    func fetchProjects(projectsService: ProjectsServiceProtocol) {
        guard let user = currentUser
            else {
                return
        }
        
        projectsService
            .fetchProjects(for: user)
            .subscribe(onNext: { [weak self] projects in
                self?.projects = projects
                self?.reloadSections()
                }, onError: { error in
                    self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        sortingRule
            .asObservable()
            .subscribe { [weak self] _ in
                self?.reloadSections()
        }
        .disposed(by: disposeBag)
    }
    
    func logout() {
        AuthenticatedContext.removeCredentials()
        FlowController.shared.logout()
    }
    
    // MARK: - Helpers
    
    private func reloadSections() {
        sections.accept(sectionsValue)
    }
}
