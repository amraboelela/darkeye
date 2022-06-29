
import Vapor
import DarkEyeCore

struct LinkModel: Codable {
    var url: String
    var title: String
    var html: String
    var numberOfReports: Int
    var blocked: Bool?
    
    static func from(link: Link) -> LinkModel {
        var theLink = link
        theLink.saveChildrenIfNeeded()
        theLink.loadHTML()
        var linkHtml = theLink.html ?? ""
        for (rawURL, refinedURL) in theLink.urls {
            print("rawURL: \(rawURL)")
            print("refinedURL: \(refinedURL)")
            let hash = refinedURL.hashBase32(numberOfDigits: 12)
            print("refinedURL hash: \(hash)")
            linkHtml = linkHtml.replacingOccurrences(of: "href=\"" + rawURL + "\"", with: "href=\"/darkeye/v/" + hash + "\"")
        }
        return LinkModel(url: theLink.url, title: theLink.title, html: linkHtml, numberOfReports: theLink.numberOfReports, blocked: theLink.blocked)
    }
    
    static func modelsWith(links: [Link], loggedInUser: User?) -> [LinkModel] {
        return links.compactMap { link in
            var linkModel = from(link: link)
            return linkModel
        }
    }

}
