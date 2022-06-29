
import Vapor
import Leaf
import DarkEyeCore

struct DarkEyeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", use: darkEyeHandler)
        routes.get("darkeye", ":search", use: searchHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) -> EventLoopFuture<View> {
        return mainPage(req: req)
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
    
    // MARK: - Helper methods
    
    func mainPage(req: Request) -> EventLoopFuture<View> {
        /*let links = Link.links(
            withSearchText: "",
            count: DarkEyeModel.linksCount
        )*/
        return req.view.render("darkeye", DarkEyeModel.modelWith(req: req, title: "Dark Eye", wordLinks: [WordLink]()))
    }
    
}
