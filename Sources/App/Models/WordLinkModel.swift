
import Vapor
import DarkEyeCore

struct WordLinkModel: Codable {
    var url: String
    var hash: String
    var title: String
    var html: String
    
    static func from(wordLink: WordLink, searchText: String) async -> WordLinkModel {
        let link: Link? = await database.valueForKey(Link.prefix + wordLink.url)
        //let link = await wordLink.hashLink()?.link()
        var html = wordLink.text
        let searchTokens = searchText.components(separatedBy: " ")
        for searchToken in searchTokens {
            if let range = html.range(of: searchToken, options: .caseInsensitive) {
                let rangeToken = html[range]
                html = html.replacingOccurrences(of: rangeToken, with: "<b>\(rangeToken)</b>")
            }
        }
        if let link = link, !link.title.isEmpty {
            return WordLinkModel(url: link.url, hash: link.hash, title: link.title, html: html)
        } else {
            return WordLinkModel(url: "", hash: wordLink.url.hashBase32(numberOfDigits: 12), title: link?.url ?? "No Title", html: html)
        }
    }
    
    static func modelsWith(wordLinks: [WordLink], searchText: String, loggedInUser: User?) async -> [WordLinkModel] {
        return await wordLinks.asyncCompactMap { wordLink in
            let wordLinkModel = await from(wordLink: wordLink, searchText: searchText)
            return wordLinkModel
        }
    }
}
