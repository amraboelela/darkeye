
import Vapor
import DarkEyeCore

struct LinkModel: Codable {
    var url: String
    var title: String
    
    static func from(link: Link) -> LinkModel {
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
        return LinkModel(url: link.url, title: link.title ?? "")
    }
    
    static func modelsWith(links: [Link], loggedInUser: User?) -> [LinkModel] {
        return links.compactMap { link in
            var linkModel = from(link: link)
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
            return linkModel
        }
    }
}
