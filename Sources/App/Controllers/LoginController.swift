
import Vapor
import Leaf
import DarkEyeCore

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", "login", use: loginHandler)
        routes.post("darkeye", "login", use: login)
        routes.get("darkeye", "logout", use: logoutHandler)
    }
    
    func loginHandler(_ req: Request) -> EventLoopFuture<View> {
        return req.view.render("login")
    }
    
    func login(_ req: Request) throws -> EventLoopFuture<Response> {
        var userModel = try req.content.decode(UserModel.self)
        print("userModel: \(userModel)")
        if userModel.username.isVacant {
            userModel.usernameErrorMessage = "Username required"
        } else if userModel.password == nil || userModel.password?.isVacant == true {
            userModel.passwordErrorMessage = "Password required"
        } else if User.usernameExists(userModel.username) {
            var user = User.userWith(username: userModel.username) ?? User.createWith(username: userModel.username)
            if user.password == userModel.password?.base64() {
                if user.userStatus == .suspended {
                    userModel.errorMessage = "This account has been suspended"
                } else {
                    let sessionID = UUID().uuidString
                    session.sessions[sessionID] = userModel.username
                    let response = req.redirect(to: "/")
                    let expiryDate = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 7)) // one week
                    let cookieExpiryDate = expiryDate.cookieFormattedString
                    let cookieValue = "sessionID=\(sessionID); Expires=\(cookieExpiryDate); Path=/; SameSite=Lax"
                    response.headers.add(name: "set-cookie", value: cookieValue)
                    
                    user.timeLoggedin = Date.secondsSinceReferenceDate
                    database[User.prefix + user.username] = user
                    
                    return req.eventLoop.makeSucceededFuture(response)
                }
            } else {
                userModel.errorMessage = "Username or password error"
            }
        } else {
            userModel.errorMessage = "Username or password error"
        }
        return req.view.render("login", userModel).flatMap { view in
            return view.encodeResponse(for: req).flatMap { response in
                return req.eventLoop.makeSucceededFuture(response)
            }
        }
    }
    
    func logoutHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        let response = req.redirect(to: "/darkeye")
        session.sessions[req.sessionID] = nil
        return req.eventLoop.makeSucceededFuture(response)
    }
}
