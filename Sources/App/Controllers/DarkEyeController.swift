
import Vapor
import Leaf
import DarkEyeCore

struct DarkEyeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", use: darkEyeHandler)
        routes.get("darkeye", "stop", use: stopHandler)
        routes.get("darkeye", ":search", use: searchHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) -> EventLoopFuture<View> {
        crawler.stop()
        crawler.start(after: 1)
        return req.view.render("darkeye", DarkEyeModel.modelWith(req: req, title: "Dark Eye", wordLinks: [WordLink]()))
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<View> {
        crawler.stop()
        let command = req.parameters.get("search") ?? ""
        if command != "search" {
            print("command != search")
        }
        let searchText = req.query[String.self, at: "text"] ?? ""
        print("searchText: \(searchText)")
        let links = WordLink.wordLinks(withSearchText: searchText, count: DarkEyeModel.linksCount)
        let darkEyeModel = DarkEyeModel.modelWith(req: req, title: "Dark Eye search: " + searchText, searchText: searchText, wordLinks: links)
        crawler.start(after: 1)
        return req.view.render("darkeye", darkEyeModel)
    }
    
    func stopHandler(_ req: Request) -> EventLoopFuture<View> {
        appController.exitTheApp()
        return req.view.render("stop")
    }
    
}
