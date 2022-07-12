
import DarkEyeCore
import Foundation

let appController = AppController()

class AppController: CrawlerDelegate {
    
    func crawlerStopped() {
        exit(0)
    }

    func exitTheApp() {
        crawler.delegate = self
        crawler.stop()
    }
    
    func stopTheApp() {
        crawler.delegate = nil
        crawler.stop()
    }
    
    func startTheApp() {
        crawler.delegate = nil
        crawler.start()
    }
}
