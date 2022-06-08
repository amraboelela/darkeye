
import Vapor
import Foundation

let webserverUtil = WebserverUtil()

class WebserverUtil {
    
    init() {
        
    }
    
    func imageSize(req: Request?) -> Int {
        var result = 37
        if let req = req {
            if "\(req)".contains("iPhone OS") {
                result = 50
            }
        }
        return result
    }
    
    func topPadding(req: Request?) -> Int {
        var result = 0
        if let req = req {
            if "\(req)".contains("iPhone OS") {
                result = 10
            }
        }
        return result
    }
}
