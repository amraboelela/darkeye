
import DarkEyeCore
import NIOPosix
import Vapor
import VaporCommon

struct DarkEyeModel: Codable {
    static let linksCount = 20
    
    var loggedInUser: User?
    var title: String
    var isAdmin: Bool
    var searchText: String?
    var isMobile: Bool
    var linksModels: [LinkModel]
    
    static func modelWith(req: Request, title: String, searchText: String = "", links: [Link]) -> DarkEyeModel {
        let loggedInUser = session.userAt(sessionID: req.sessionID)
        return DarkEyeModel(
            loggedInUser: loggedInUser,
            title: title,
            isAdmin: loggedInUser?.userRole == .admin,
            searchText: searchText,
            isMobile: req.fromMobile,
            linksModels: LinkModel.modelsWith(links: links, loggedInUser: loggedInUser)
        )
    }
}

struct SearchModel: Codable {
    var text: String
}
