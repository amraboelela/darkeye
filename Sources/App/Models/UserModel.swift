
import Vapor
import DarkEyeCore

struct UserModel: Codable {
    var username: String
    //var privateKey: String?
    var fullname: String?
    var errorMessage: String?
    var usernameErrorMessage: String?
    //var privateKeyErrorMessage: String?
    
    var user: User {
        var result = User.userWith(username: username)
        return result
    }
    
    static func modelWith(username: String) -> UserModel {
        let user = User.userWith(username: username)
        return UserModel(username: username)
    }
}
