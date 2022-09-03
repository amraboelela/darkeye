
import Vapor
import DarkEyeCore

struct UserModel: Codable {
    var username: String
    var password: String?
    var confirmPassword: String?
    var url: String?
    var errorMessage: String?
    var usernameErrorMessage: String?
    var passwordErrorMessage: String?
    var confirmPasswordErrorMessage: String?
    var success: Bool?
    
    func user() async -> User {
        var result = await User.userWith(username: username) ?? User.createWith(username: username)
        if let password = password {
            result.password = password.base64()
        }
        if let url = url, !url.isVacant {
            result.url = url
        }
        return result
    }
    
    var usernameIsValid: Bool {
        let characters = CharacterSet(charactersIn: "_0123456789abcdefghijklmnopqrstuvwxyz")
        if username.rangeOfCharacter(from: characters.inverted) != nil {
            return false
        } else {
            return true
        }
    }
    
    static func modelWith(username: String) async -> UserModel {
        let user = await User.userWith(username: username) ?? User.createWith(username: username)
        return UserModel(username: username, password: user.password, confirmPassword: user.password, url: user.url)
    }
}
