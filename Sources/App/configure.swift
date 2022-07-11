
import NIOSSL
import Vapor
import Leaf
import DarkEyeCore

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
    
    database = Database(parentPath: app.directory.workingDirectory + "Library", name: "Database")
    Link.workingDirectory = app.directory.workingDirectory
    //print("Starting the crawler")
    crawler.delegate = appController
    //crawler.start()
    
    // register routes
    try routes(app)
}
