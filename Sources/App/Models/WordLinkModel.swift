
import Vapor
import DarkEyeCore

struct WordLinkModel: Codable {
    var url: String
    var text: String
    /*var wordCount: Int
    var numberOfVisits: Int = 0
    var lastVisitTime: Int = 0
    */
    
    static func from(wordLink: WordLink) -> WordLinkModel {
        /*let user = User.userWith(username: post.username) ?? User.createWith(username: post.username)
        var hasImage = false
        let postImageFile = application.directory.publicDirectory + "postimages/\(post.time)-" + user.username + ".png"
        if FileManager.default.fileExists(atPath: postImageFile) {
            hasImage = true
        }
        var replyToPostModel: ReplyToPostModel?
        if let replyToPostKey = post.replyTo, let replyToPost = Post.postWith(key: replyToPostKey) {
            replyToPostModel = ReplyToPostModel.from(post: replyToPost)
        }*/
        return WordLinkModel(url: wordLink.url, text: wordLink.text)
    }
    
    static func modelsWith(wordLinks: [WordLink], loggedInUser: User?) -> [WordLinkModel] {
        return wordLinks.compactMap { wordLink in
            let wordLinkModel = from(wordLink: wordLink)
            //var message = post.message
            /*if isHtmlMessage == true {
                message = message.htmlMessage
            }*/
            //postModel.message = message
            /*var replyToPostModel: ReplyToPostModel?
            if let replyToPostKey = post.replyTo, let replyToPost = Post.postWith(key: replyToPostKey) {
                replyToPostModel = ReplyToPostModel.from(post: replyToPost)
            }
            postModel.replyTo = replyToPostModel
            postModel.canDelete = loggedInUser?.username == post.username || loggedInUser?.moderatorOrAdmin == true*/
            return wordLinkModel
        }
    }
}
