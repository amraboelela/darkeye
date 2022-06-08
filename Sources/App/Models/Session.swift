
import Vapor
import DarkEyeCore

let session = Session()
class Session {
    var sessions = [String: UserSession]()
}

struct UserSession {
    var username: String
    
    var userModel: UserModel {
        let result = UserModel.modelWith(username: username)
        return result
    }
}
