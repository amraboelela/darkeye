
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
    
    func linkHandler(_ req: Request) async throws -> View {
        let hash = req.parameters.get("hash") ?? ""
        if let link = await HashLink.linkWith(hash: hash) {
            return try await req.view.render("link", LinkModel.from(link: link))
        }
        return try await req.view.render("link")
    }
    
    func blockLink(_ req: Request) async throws -> View {
        let hash = req.parameters.get("hash") ?? ""
        if let link = await HashLink.linkWith(hash: hash), var site = await link.site() {
            site.blocked = true
            await site.save()
            return try await req.view.render("link", LinkModel.from(link: link))
        }
        return try await req.view.render("link")
    }
    
    func reportLink(_ req: Request) async throws -> View {
        let hash = req.parameters.get("hash") ?? ""
        if let link = await HashLink.linkWith(hash: hash), var site = await link.site() {
            site.numberOfReports += 1
            await site.save()
            return try await req.view.render("link", LinkModel.from(link: link))
        }
        return try await req.view.render("link")
    }
}
