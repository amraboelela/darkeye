
import Vapor
import Leaf
import DarkEyeCore
import SwiftLevelDB

struct LinkController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", "v", ":hash", use: linkHandler)
        routes.get("darkeye", "block", ":hash", use: blockLink)
        routes.get("darkeye", "report", ":hash", use: reportLink)
    }
    
    // MARK: - route Handlers
    
    func linkHandler(_ req: Request) -> EventLoopFuture<View> {
        appController.stopTheApp()
        defer {
            crawler.start(after: 1)
        }
        let hash = req.parameters.get("hash") ?? ""
        if let link = HashLink.linkWith(hash: hash) {
            return req.view.render("link", LinkModel.from(link: link))
        }
        return req.view.render("link")
    }
    
    func blockLink(_ req: Request) -> EventLoopFuture<View> {
        let hash = req.parameters.get("hash") ?? ""
        if var link = HashLink.linkWith(hash: hash) {
            link.blocked = true
            link.save()
            return req.view.render("link", LinkModel.from(link: link))
        }
        return req.view.render("link")
    }
    
    func reportLink(_ req: Request) -> EventLoopFuture<View> {
        let hash = req.parameters.get("hash") ?? ""
        if var link = HashLink.linkWith(hash: hash) {
            link.numberOfReports += 1
            link.save()
            return req.view.render("link", LinkModel.from(link: link))
        }
        return req.view.render("link")
    }
}
