import Vapor
import DarkEyeCore

func routes(_ app: Application) throws {
    
    try app.register(collection: DarkEyeController())
    try app.register(collection: LoginController())
    try app.register(collection: LinkController())
    try app.register(collection: StaticPagesController())
}
