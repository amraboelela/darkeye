
import Vapor
import Leaf
import DarkEyeCore

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", "login", use: loginHandler)
        routes.post("darkeye", "login", use: login)
        routes.get("darkeye", "logout", use: logoutHandler)
    }
    
    func loginHandler(_ req: Request) async throws -> View {
        return try await req.view.render("login")
    }
    
    func login(_ req: Request) async throws -> Response {
        var userModel = try req.content.decode(UserModel.self)
        print("userModel: \(userModel)")
        if userModel.username.isVacant {
            userModel.usernameErrorMessage = "Username required"
        } else if userModel.password == nil || userModel.password?.isVacant == true {
            userModel.passwordErrorMessage = "Password required"
        } else if await User.usernameExists(userModel.username) {
            var user = await User.userWith(username: userModel.username) ?? User.createWith(username: userModel.username)
            if user.password == userModel.password?.base64() {
                if user.userStatus == .suspended {
                    userModel.errorMessage = "This account has been suspended"
                } else {
                    let sessionID = UUID().uuidString
                    session.sessions[sessionID] = userModel.username
                    let response = req.redirect(to: "/darkeye")
                    let expiryDate = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 7)) // one week
                    let cookieExpiryDate = expiryDate.cookieFormattedString
                    let cookieValue = "sessionID=\(sessionID); Expires=\(cookieExpiryDate); Path=/; SameSite=Lax"
                    response.headers.add(name: "set-cookie", value: cookieValue)
                    
                    user.timeLoggedin = Date.secondsSinceReferenceDate
                    try await database.setValue(user, forKey: User.prefix + user.username)
                    return response
                }
            } else {
                userModel.errorMessage = "Username or password error"
            }
        } else {
            userModel.errorMessage = "Username or password error"
        }
        let view: View = try await req.view.render("login", userModel)
        return try await view.encodeResponse(for: req)
    }
    
    func logoutHandler(_ req: Request) -> Response {
        let response = req.redirect(to: "/darkeye")
        session.sessions[req.sessionID] = nil
        return response
    }
}
