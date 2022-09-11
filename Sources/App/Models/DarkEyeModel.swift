
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
    var isTorBrowser: Bool
    var wordLinksModels: [WordLinkModel]
    
    static func modelWith(req: Request, title: String, searchText: String = "", wordLinks: [WordLink]) async -> DarkEyeModel {
        let loggedInUser = await session.userAt(sessionID: req.sessionID)
        return await DarkEyeModel(
            loggedInUser: loggedInUser,
            title: title,
            isAdmin: loggedInUser?.userRole == .admin,
            searchText: searchText,
            isMobile: req.fromMobile,
            isTorBrowser: req.fromTorBrowser,
            wordLinksModels: WordLinkModel.modelsWith(wordLinks: wordLinks, searchText: searchText, loggedInUser: loggedInUser)
        )
    }
}
