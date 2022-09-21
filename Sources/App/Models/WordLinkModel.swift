
import Vapor
import DarkeyeCore

struct ChildWordLinkModel: Codable {
    var url: String
    var hash: String
    var title: String
    var html: String
    
    static func from(childWordLink: ChildWordLink, searchText: String) async -> ChildWordLinkModel {
        let link: Link? = await database.value(forKey: Link.prefix + childWordLink.url)
        let html = childWordLink.text.htmlWith(searchText: searchText)
        if let link = link, let title = link.title, !title.isEmpty {
            return ChildWordLinkModel(url: link.url, hash: link.hash, title: title, html: html)
        } else {
            return ChildWordLinkModel(url: "", hash: childWordLink.url.hashBase32(numberOfDigits: 12), title: link?.url ?? "No Title", html: html)
        }
    }
    
    static func modelsWith(childWordLinks: [ChildWordLink]?, searchText: String) async -> [ChildWordLinkModel]? {
        return await childWordLinks?.asyncCompactMap { childWordLink in
            let childWordLinkModel = await from(childWordLink: childWordLink, searchText: searchText)
            return childWordLinkModel
        }
    }
}

struct WordLinkModel: Codable {
    static let childCount = 2
    
    var url: String
    var hash: String
    var title: String
    var html: String
    var allChildren: [ChildWordLinkModel]?
    var showAllChildren = false
    var topChildren: [ChildWordLinkModel]?
    var hasMoreChildren = false
    
    static func from(
        wordLink: WordLink,
        searchText: String,
        moreHash: String?
    ) async -> WordLinkModel {
        let link: Link? = await database.value(forKey: Link.prefix + wordLink.url)
        let html = wordLink.text.htmlWith(searchText: searchText)
        let allChildren = await ChildWordLinkModel.modelsWith(childWordLinks: wordLink.children, searchText: searchText)
        let hash = wordLink.url.hashBase32(numberOfDigits: 12)
        var showAllChildren = false
        if let moreHash = moreHash {
            showAllChildren = moreHash == hash
        }
        var topChildren = allChildren
        var hasMoreChildren = false
        if let allChildren = allChildren {
            if allChildren.count > childCount {
                topChildren?.removeLast(allChildren.count - childCount)
            }
            hasMoreChildren = !showAllChildren && allChildren.count > childCount
        }
        if let link = link, let title = link.title, !title.isEmpty {
            return WordLinkModel(
                url: link.url,
                hash: hash,
                title: title,
                html: html,
                allChildren: allChildren,
                showAllChildren: showAllChildren,
                topChildren: topChildren,
                hasMoreChildren: hasMoreChildren
            )
        } else {
            return WordLinkModel(
                url: "",
                hash: hash,
                title: link?.url ?? "No Title",
                html: html,
                allChildren: allChildren,
                showAllChildren: showAllChildren,
                topChildren: topChildren,
                hasMoreChildren: hasMoreChildren
            )
        }
    }
    
    static func modelsWith(wordLinks: [WordLink], searchText: String, moreHash: String?) async -> [WordLinkModel] {
        return await wordLinks.asyncCompactMap { wordLink in
            let wordLinkModel = await from(
                wordLink: wordLink,
                searchText: searchText,
                moreHash: moreHash
            )
            return wordLinkModel
        }
    }
}
