
import Vapor
import DarkeyeCore

struct LinkModel: Codable {
    var url: String
    var title: String
    var html: String
    var numberOfReports: Int
    var allowed: Bool
    
    static func from(link: Link) async -> LinkModel {
        var theLink = link
        await theLink.saveChildrenIfNeeded()
        var linkHtml = await theLink.html() ?? ""
        for (rawURL, refinedURL) in await theLink.urls() {
            //print("rawURL: \(rawURL)")
            let hash = refinedURL.hashBase32(numberOfDigits: 12)
            linkHtml = linkHtml.replacingOccurrences(of: "href=\"" + rawURL + "\"", with: "href=\"/darkeye/v/" + hash + "\"")
        }
        return await LinkModel(url: theLink.url, title: theLink.title(), html: linkHtml, numberOfReports: theLink.site()?.numberOfReports ?? 0, allowed: theLink.site()?.allowed ?? true)
    }
    
    static func modelsWith(links: [Link], loggedInUser: User?) async -> [LinkModel] {
        return await links.asyncCompactMap { link in
            return await from(link: link)
        }
    }

}
