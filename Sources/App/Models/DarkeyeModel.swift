
import DarkeyeCore
import NIOPosix
import Vapor
import VaporCommon

struct DarkeyeModel: Codable {
    static let title = "Darkeye legal search engine for DarkNet (the Dark Web)"
    static let linksCount = 200
    
    var loggedInUser: User?
    var title: String
    var isAdmin: Bool
    var searchText: String?
    var isMobile: Bool
    var isTorBrowser: Bool
    var wordLinksModels: [WordLinkModel]
    
    static func modelWith(
        req: Request,
        title: String,
        searchText: String = "",
        wordLinks: [WordLink],
        moreHash: String? = nil
    ) async -> DarkeyeModel {
        let loggedInUser = await session.userAt(sessionID: req.sessionID)
        return await DarkeyeModel(
            loggedInUser: loggedInUser,
            title: title,
            isAdmin: loggedInUser?.userRole == .admin,
            searchText: searchText,
            isMobile: req.fromMobile,
            isTorBrowser: req.fromTorBrowser,
            wordLinksModels: WordLinkModel.modelsWith(
                wordLinks: wordLinks,
                searchText: searchText,
                moreHash: moreHash
            )
        )
    }
}
