
import Vapor
import DarkEyeCore

struct WordLinkModel: Codable {
    var url: String
    var hash: String
    var title: String
    var text: String
    
    static func from(wordLink: WordLink) -> WordLinkModel {
        let link = wordLink.hashLink?.link
        return WordLinkModel(url: link?.url ?? "", hash: wordLink.urlHash, title: link?.title ?? "", text: wordLink.text)
    }
    
    static func modelsWith(wordLinks: [WordLink], loggedInUser: User?) -> [WordLinkModel] {
        return wordLinks.compactMap { wordLink in
            let wordLinkModel = from(wordLink: wordLink)
            return wordLinkModel
        }
    }
}
