import Foundation

enum NetworkError: Int, Error {

    case decodingError
    case invalidRequest
    case unauthorized
    case invalidCredentials
    
    var localizedDescription: String {
        switch self {
        case .decodingError, .invalidRequest:
            return "An error has occured"
        case .invalidCredentials:
            return "Invalid credentials"
        case .unauthorized:
            return "Unauthorized"
        }
    }
}
