
import Vapor
import DarkEyeCore

struct WordLinkModel: Codable {
    var url: String
    var hash: String
    var title: String
    var html: String
    
    static func from(wordLink: WordLink, searchText: String) -> WordLinkModel {
        let link = wordLink.hashLink?.link
        var html = wordLink.text
        let searchTokens = searchText.components(separatedBy: " ")
        for searchToken in searchTokens {
            if let range = html.range(of: searchToken, options: .caseInsensitive) {
                let rangeToken = html[range]
                html = html.replacingOccurrences(of: rangeToken, with: "<b>\(rangeToken)</b>")
            }
        }
        if let title = link?.title, !title.isEmpty {
            return WordLinkModel(url: link?.url ?? "", hash: wordLink.urlHash, title: title, html: html)
        } else {
            return WordLinkModel(url: "", hash: wordLink.urlHash, title: link?.url ?? "No Title", html: html)
        }
    }
    
    static func modelsWith(wordLinks: [WordLink], searchText: String, loggedInUser: User?) -> [WordLinkModel] {
        return wordLinks.compactMap { wordLink in
            let wordLinkModel = from(wordLink: wordLink, searchText: searchText)
            return wordLinkModel
        }
    }
}
