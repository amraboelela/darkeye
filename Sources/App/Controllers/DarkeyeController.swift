
import Vapor
import Leaf
import DarkeyeCore

struct DarkeyeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: darkEyeHandler)
        routes.get("darkeye", use: darkEyeHandler)
        routes.get("darkeye", ":search", use: searchHandler)
        routes.get("darkeye", "stop", use: stopHandler)
        routes.get("darkeye", "start", use: startHandler)
        routes.get("darkeye", "exit", use: exitHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) async throws -> View {
        return try await req.view.render("darkeye", DarkeyeModel.modelWith(req: req, title: DarkeyeModel.title, wordLinks: [WordLink]()))
    }
    
    func searchHandler(_ req: Request) async throws -> View {
        let command = req.parameters.get("search") ?? ""
        if command != "search" {
            print("command != search")
        }
        let searchText = req.query[String.self, at: "text"] ?? ""
        print("searchText: \(searchText)")
        let moreHash = req.query[String.self, at: "more"] ?? ""
        print("moreHash: \(moreHash)")
        let wordLinks = await WordLink.wordLinks(withSearchText: searchText, count: DarkeyeModel.linksCount)
        let darkEyeModel = await DarkeyeModel.modelWith(
            req: req,
            title: DarkeyeModel.title + " search: " + searchText,
            searchText: searchText,
            wordLinks: wordLinks,
            moreHash: moreHash
        )
        return try await req.view.render("darkeye", darkEyeModel)
    }
    
    func stopHandler(_ req: Request) async throws -> View {
        try await appController.stopTheApp()
        return try await req.view.render("stop")
    }
    
    func startHandler(_ req: Request) async throws -> View {
        try await appController.startTheApp()
        return try await req.view.render("start")
    }
    
    func exitHandler(_ req: Request) async throws -> View {
        try await appController.exitTheApp()
        return try await req.view.render("exit")
    }
}
