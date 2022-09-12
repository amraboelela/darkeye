import Vapor
import DarkeyeCore

func routes(_ app: Application) throws {
    
    try app.register(collection: DarkeyeController())
    try app.register(collection: LoginController())
    try app.register(collection: LinkController())
    try app.register(collection: StaticPagesController())
}
