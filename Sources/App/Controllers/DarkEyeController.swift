
import Vapor
import Leaf
import DarkEyeCore

struct DarkEyeController: RouteCollection {
    let linksCount = 200
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", use: darkEyeHandler)
        routes.get("darkeye", ":search", use: searchHandler)
    }
    
    // MARK: - route Handlers
    
    func darkEyeHandler(_ req: Request) -> EventLoopFuture<View> {
        _ = Post.newPosts
        let links = Link.links(withSearchText: "", count: linksCount)
        var darkEyeModel = DarkEyeModel.modelWith(req: req, title: "Dark Eye", posts: posts)
        if let userSession = session.sessions[req.sessionID] {
            darkEyeModel.userModel = userSession.userModel
        }
        return req.view.render("darkeye", darkEyeModel)
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<View> {
        let searchModel = try req.content.decode(SearchModel.self)
        print("searchModel: \(searchModel)")
        let searchText = searchModel.text
        let links = Link.links(withSearchText: searchText, count: DarkEyeModel.linksCount)
        let darkeyeModel = DarkEyeModel.modelWith(req: req, title: "Dark Eye, search: \(searchText)", links: links)
        
        //let HaneinModel = HaneinModel.modelWith(req: req, title: "حنين ـ البحث ـ " + searchText, searchText: searchText, posts: posts)
        return req.view.render("darkeye", DarkEyeModel)
    }
    
}
