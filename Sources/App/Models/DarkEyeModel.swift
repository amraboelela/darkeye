
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
    var wordLinksModels: [WordLinkModel]
    
    static func modelWith(req: Request, title: String, searchText: String = "", wordLinks: [WordLink]) -> DarkEyeModel {
        let loggedInUser = session.userAt(sessionID: req.sessionID)
        return DarkEyeModel(
            loggedInUser: loggedInUser,
            title: title,
            isAdmin: loggedInUser?.userRole == .admin,
            searchText: searchText,
            isMobile: req.fromMobile,
            wordLinksModels: WordLinkModel.modelsWith(wordLinks: wordLinks, loggedInUser: loggedInUser)
        )
    }
}
