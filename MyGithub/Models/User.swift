import Foundation

struct User: Codable {
    let fullName: String
    let userName: String
    let avatarUrl: String
    let reposUrl: String
    let twoFactorAuthentication: Bool
    
    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case userName = "login"
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
        case twoFactorAuthentication = "two_factor_authentication"
    }
}
