
import Vapor
import Leaf
import DarkEyeCore

struct DarkEyeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: darkEyeHandler)
        //routes.get("avatar", ":image", use: imageHandler)
        routes.post("search", use: searchHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) -> EventLoopFuture<View> {
        return mainPage(req: req)
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<View> {
        let searchModel = try req.content.decode(SearchModel.self)
        print("searchModel: \(searchModel)")
        let searchText = searchModel.text
        let links = Link.links(withSearchText: searchText, count: DarkEyeModel.linksCount)
        let darkEyeModel = DarkEyeModel.modelWith(req: req, title: "Dark Eye search: " + searchText, searchText: searchText, links: links)
        return req.view.render("darkeye", darkEyeModel)
    }
    
    /*func closeRegistration(_ req: Request) -> EventLoopFuture<View> {
        if session.isUserAdminAt(request: req) {
            Registration.changeRegistration(toOpen: false)
        }
        return mainPage(req: req)
    }
    
    func openRegistration(_ req: Request) -> EventLoopFuture<View> {
        if session.isUserAdminAt(request: req) {
            Registration.changeRegistration(toOpen: true)
        }
        return mainPage(req: req)
    }*/
    
    // MARK: - Helper methods
    
    func mainPage(req: Request) -> EventLoopFuture<View> {
        let links = Link.links(
            withSearchText: "",
            count: DarkEyeModel.linksCount
        )
        return req.view.render("darkeye", DarkEyeModel.modelWith(req: req, title: "Dark Eye", links: links))
    }
    
}
