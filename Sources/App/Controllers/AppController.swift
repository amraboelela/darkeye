
import DarkeyeCore
import Foundation

let appController = AppController()

class AppController: CrawlerDelegate {
    var withError = false
    
    func crawlerStopped() {
        var errorCode = withError ? 1 : 0
        NSLog("exit(\(errorCode)")
        exit(Int32(errorCode))
    }

    func exitTheApp() async throws {
        withError = false
        let crawler = await Crawler.shared()
        crawler.delegate = self
        await crawler.stop()
    }
    
    func exitTheAppWithError() async throws {
        withError = true
        let crawler = await Crawler.shared()
        crawler.delegate = self
        await crawler.stop()
    }
    
    func stopTheApp() async throws {
        let crawler = await Crawler.shared()
        crawler.delegate = nil
        await crawler.stop()
    }
    
    func startTheApp() async throws {
        let crawler = await Crawler.shared()
        crawler.delegate = nil
        await crawler.start()
    }
}
