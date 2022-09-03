
import DarkEyeCore
import Foundation

let appController = AppController()

class AppController: CrawlerDelegate {
    
    func crawlerStopped() {
        exit(0)
    }

    func exitTheApp() async throws {
        let crawler = try await Crawler.shared()
        crawler.delegate = self
        await crawler.stop()
    }
    
    func stopTheApp() async throws {
        let crawler = try await Crawler.shared()
        crawler.delegate = nil
        await crawler.stop()
    }
    
    func startTheApp() async throws {
        let crawler = try await Crawler.shared()
        crawler.delegate = nil
        await crawler.start()
    }
}
