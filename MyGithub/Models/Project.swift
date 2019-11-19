import Foundation

struct Project: Codable {
    let name: String
    let description: String
    let stars: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case stars = "stargazers_count"
    }
}
