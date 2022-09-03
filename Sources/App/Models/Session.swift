
import Vapor
import DarkEyeCore

let session = Session()
class Session {
    var sessions = [String: String]()
    
    func userAt(sessionID: String) async -> User? {
        if let username = sessions[sessionID], let user = await User.userWith(username: username) {
            if user.userStatus != .suspended {
                return user
            }
        }
        return nil
    }
    
    func isUserAdminAt(request: Request) async -> Bool {
        if let loggedinUser = await userAt(sessionID: request.sessionID), loggedinUser.userRole == .admin {
            return true
        }
        return false
    }
    
    func isUserModeratorOrAdminAt(request: Request) async -> Bool {
        if let loggedinUser = await userAt(sessionID: request.sessionID) {
            if loggedinUser.userRole == .moderator || loggedinUser.userRole == .admin {
                return true
            }
        }
        return false
    }
}
