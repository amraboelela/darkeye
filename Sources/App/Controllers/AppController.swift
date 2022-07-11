
//import Vapor
//import Leaf
import DarkEyeCore
import Foundation

let appController = AppController()

class AppController: CrawlerDelegate {
    
    func crawlerStopped() {
        exit(0)
    }

    func exitTheApp() {
        //crawler.stop()
    }
}
