import Foundation

class AppContext {

    var currentUser: User?
    
    // MARK: Shared Instance
    
    static let shared = AppContext()
    private init() { }
}
