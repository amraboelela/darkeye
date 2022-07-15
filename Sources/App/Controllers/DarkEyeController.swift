
import Vapor
import Leaf
import DarkEyeCore

struct DarkEyeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", use: darkEyeHandler)
        routes.get("darkeye", ":search", use: searchHandler)
        routes.get("darkeye", "stop", use: stopHandler)
        routes.get("darkeye", "start", use: startHandler)
        routes.get("darkeye", "exit", use: exitHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) -> EventLoopFuture<View> {
        return req.view.render("darkeye", DarkEyeModel.modelWith(req: req, title: "Dark Eye", wordLinks: [WordLink]()))
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<View> {
        let command = req.parameters.get("search") ?? ""
        if command != "search" {
            print("command != search")
        }
        let searchText = req.query[String.self, at: "text"] ?? ""
        print("searchText: \(searchText)")
        let links = WordLink.wordLinks(withSearchText: searchText, count: DarkEyeModel.linksCount)
        let darkEyeModel = DarkEyeModel.modelWith(req: req, title: "Dark Eye search: " + searchText, searchText: searchText, wordLinks: links)
        return req.view.render("darkeye", darkEyeModel)
    }
    
    func stopHandler(_ req: Request) -> EventLoopFuture<View> {
        appController.stopTheApp()
        return req.view.render("stop")
    }
    
    func startHandler(_ req: Request) -> EventLoopFuture<View> {
        appController.startTheApp()
        return req.view.render("start")
    }
    
    func exitHandler(_ req: Request) -> EventLoopFuture<View> {
        appController.exitTheApp()
        return req.view.render("exit")
    }
}
