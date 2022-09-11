
import NIOSSL
import Vapor
import Leaf
import DarkEyeCore
import SwiftLevelDB

var application: Application!
var publicURL = NSURL(fileURLWithPath: application.directory.publicDirectory, isDirectory: true)

// configures your application
public func configure(_ app: Application) throws {
    application = app
    /// config max upload file size
    app.routes.defaultMaxBodySize = "10mb"
    
    /// setup public file middleware (for hosting our uploaded files)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)
    
    database = LevelDB(parentPath: app.directory.workingDirectory + "Library", name: "Database")
    Global.workingDirectory = app.directory.workingDirectory

    Task(priority: .background) {
        let crawler = await Crawler.shared()
        await crawler.start()
    }
    // register routes
    try routes(app)
}
