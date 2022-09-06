
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
        await theLink.saveChildrenIfNeeded()
        var linkHtml = theLink.html ?? ""
        for (rawURL, refinedURL) in theLink.urls {
            //print("rawURL: \(rawURL)")
            let hash = refinedURL.hashBase32(numberOfDigits: 12)
            //print("refinedURL hash: \(hash)")
            linkHtml = linkHtml.replacingOccurrences(of: "href=\"" + rawURL + "\"", with: "href=\"/darkeye/v/" + hash + "\"")
        }
        return await LinkModel(url: theLink.url, title: theLink.title, html: linkHtml, numberOfReports: theLink.site()?.numberOfReports ?? 0, blocked: theLink.site()?.blocked ?? false)
    }
    
    static func modelsWith(links: [Link], loggedInUser: User?) async -> [LinkModel] {
        return await links.asyncCompactMap { link in
            return await from(link: link)
        }
    }

}
