
import Vapor
import DarkEyeCore

let session = Session()
class Session {
    var sessions = [String: String]()
    
    func userAt(sessionID: String) -> User? {
        if let username = sessions[sessionID], let user = User.userWith(username: username) {
            if user.userStatus != .suspended {
                return user
            }
        }
        return nil
    }
    
    func isUserAdminAt(request: Request) -> Bool {
        if let loggedinUser = userAt(sessionID: request.sessionID), loggedinUser.userRole == .admin {
            return true
        }
        return false
    }
    
    func isUserModeratorOrAdminAt(request: Request) -> Bool {
        if let loggedinUser = userAt(sessionID: request.sessionID) {
            if loggedinUser.userRole == .moderator || loggedinUser.userRole == .admin {
                return true
            }
        }
        return false
    }
}
