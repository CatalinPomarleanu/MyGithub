import Foundation

fileprivate let UserCredentialsLoginCredentialsHost = "http://www.UserCredentialsLoginCredentialsHost.com"

class AuthenticatedContext: NSObject {

    static func setUser(user: String, password: String) {
        removeCredentials()
        let credentials = URLCredential(user: user, password: password, persistence: .permanent)
        URLCredentialStorage.shared.set(credentials, for: getProtectionSpace(host: UserCredentialsLoginCredentialsHost))
    }

    static func userAndPassword() -> (user: String?, password: String?) {
        var user: String?
        var key: String?

        let protectionSpace = getProtectionSpace(host: UserCredentialsLoginCredentialsHost)
        if let credential = getCredential(protectionSpace: protectionSpace) {
            user = credential.user
            key = credential.password
        }

        return (user, key)
    }

    static func removeCredentials() {
        let protectionSpace = getProtectionSpace(host: UserCredentialsLoginCredentialsHost)
        if let credential = getCredential(protectionSpace: protectionSpace) {
            URLCredentialStorage.shared.remove(credential, for: protectionSpace)
        }
    }
}

extension AuthenticatedContext {

    static func getProtectionSpace(host: String) -> URLProtectionSpace {
        let protectionURL = NSURL(string: host)
        return URLProtectionSpace(host: protectionURL!.host!, port: 0, protocol: protectionURL?.scheme, realm: nil, authenticationMethod: NSURLAuthenticationMethodHTTPDigest)
    }

    static func getCredential(protectionSpace: URLProtectionSpace) -> URLCredential? {
        var returnCredential: URLCredential?

        if let credentialsObject = URLCredentialStorage.shared.credentials(for: protectionSpace) {
            for (_, value) in credentialsObject {
                returnCredential = value
                break
            }
        }

        return returnCredential
    }
}
