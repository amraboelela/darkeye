
import Vapor
import DarkEyeCore

struct LinkModel: Codable {
    var url: String
    var title: String
    var html: String
    var numberOfReports: Int
    var blocked: Bool?
    
    static func from(link: Link) async -> LinkModel {
        var theLink = link
        do {
            try await theLink.saveChildrenIfNeeded()
        } catch {
            NSLog("LinkModel from:link theLink.saveChildrenIfNeeded() failed, error: \(error). Exiting.")
            exit(0)
        }
        var linkHtml = theLink.html ?? ""
        for (rawURL, refinedURL) in theLink.urls {
            //print("rawURL: \(rawURL)")
            let hash = refinedURL.hashBase32(numberOfDigits: 12)
            //print("refinedURL hash: \(hash)")
            linkHtml = linkHtml.replacingOccurrences(of: "href=\"" + rawURL + "\"", with: "href=\"/darkeye/v/" + hash + "\"")
        }
        return LinkModel(url: theLink.url, title: theLink.title, html: linkHtml, numberOfReports: theLink.numberOfReports, blocked: theLink.blocked)
    }
    
    static func modelsWith(links: [Link], loggedInUser: User?) async -> [LinkModel] {
        return await links.asyncCompactMap { link in
            return await from(link: link)
        }
    }

}
