
import Vapor
import Leaf

struct StaticPagesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("darkeye", "images", ":image", use: imageHandler)
    }
 
    func imageHandler(_ req: Request) -> EventLoopFuture<Response> {
        let imagePath = req.url.string.replacingOccurrences(of: "/darkeye/", with: "")
        let response = Response(status: .ok, headers: ["Content-Type": "image/png"])
        if let imageURL = publicURL.appendingPathComponent(imagePath, isDirectory: true) {
            if let imageData = try? Data(contentsOf: imageURL) {
                response.body = Response.Body(data: imageData)
            } else {
                print("Couldn't get imageData")
                response.status = .notFound
            }
        } else {
            print("Couldn't get siteURL")
            response.status = .notFound
        }
        return req.eventLoop.makeSucceededFuture(response)
    }
}
