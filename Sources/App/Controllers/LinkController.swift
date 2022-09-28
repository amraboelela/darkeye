
import Vapor
import Leaf
import DarkeyeCore
import SwiftLevelDB

struct LinkController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", "v", ":hash", use: linkHandler)
        routes.get("darkeye", "block", ":hash", use: blockLink)
        routes.get("darkeye", "report", ":hash", use: reportLink)
    }
    
    // MARK: - route Handlers
    
    func linkHandler(_ req: Request) async throws -> Response {
        let hash = req.parameters.get("hash") ?? ""
        var view: View
        if var link = await HashLink.linkWith(hash: hash) {
            NSLog("linkHandler viewing url: \(link.url)")
            link.numberOfVisits += 1
            link.lastVisitTime = Date.secondsSinceReferenceDate
            await link.save()
            if req.fromTorBrowser {
                let response = req.redirect(to: link.url)
                return response
            }
            view = try await req.view.render("link", LinkModel.from(link: link))
        } else {
            NSLog("linkHandler couldn't get link for hash: \(hash)")
            view = try await req.view.render("link")
        }
        return try await view.encodeResponse(for: req)
    }
    
    func blockLink(_ req: Request) async throws -> View {
        let hash = req.parameters.get("hash") ?? ""
        if var link = await HashLink.linkWith(hash: hash) {
            link.blocked = true
            await link.save()
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
