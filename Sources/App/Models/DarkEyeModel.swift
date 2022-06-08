
import DarkEyeCore
import Vapor

struct DarkEyeModel: Codable {
    //var userModel: UserModel?
    var title: String
    var imageSize: Int
    var linksModels: [LinkModel]
    
    static func modelWith(req: Request, title: String, links: [Link]) -> DarkEyeModel {
        let linkModels: [LinkModel] = links.compactMap { link in
            if let text = link.text {
                //let friendlyDateString = Date.friendlyDateStringFrom(epochTime: TimeInterval(postTime))
                //text = message.htmlMessage
                return LinkModel(
                    url: link.url,
                    title: link.title,
                    text: text
                )
            }
            return LinkModel(
                url: link.url,
                title: link.title,
                text: ""
            )
        }
        let imageSize = webserverUtil.imageSize(req: req)
        return DarkEyeModel(
            userModel: nil,
            title: title,
            imageSize: imageSize,
            postsModels: postModels
        )
    }
}
