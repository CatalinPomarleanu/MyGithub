import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire

class ProjectsViewController: UIViewController, Storyboardable {
    
    // MARK: - Parameters
    
    var viewModel: ProjectsViewModel!
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<ProjectsSection>(configureCell: { _, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(at: indexPath) as ProjectTableViewCell
        item.configure(cell)
        return cell
    })

    // MARK: - IBOutlets
    
    @IBOutlet weak var userAvatarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        title = "Projects"
        navigationItem.rightBarButtonItem = userAvatarButton
        userAvatarButton.setRemoteImage(at: viewModel.currentUser?.avatarUrl, placeholder: #imageLiteral(resourceName: "user_placeholder"))
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        sortSegmentedControl.setEnabled(true, forSegmentAt: viewModel.sortingRule.value)
    }
    
    private func bindViewModel() {
        sortSegmentedControl.rx.selectedSegmentIndex.bind(to: viewModel.sortingRule).disposed(by: disposeBag)
        
        viewModel.sections.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        viewModel.errorsSubject
            .subscribe(onNext: { [weak self] error in
                self?.presentAlert(withTitle: "Error", message: error.localizedDescription)
            })
        .disposed(by: disposeBag)
        
        userAvatarButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.presentUserSettings()
        }).disposed(by: disposeBag)
    }
    
    private func presentUserSettings() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.logout()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverPresentationController = alertController.popoverPresentationController {
            alertController.title = nil

            popoverPresentationController.barButtonItem = userAvatarButton
            popoverPresentationController.permittedArrowDirections = [.up, .down]
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
