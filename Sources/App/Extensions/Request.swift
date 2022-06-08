//
//  Request.swift
//  DarkEye
//
//  Created by Amr Aboelela on 6/7/22.
//  Copyright © 2022 Amr Aboelela. All rights reserved.
//

import Foundation
import Vapor

public extension Request {
    
    var sessionID: String {
        //print("sessionID self: \(self)")
        if let sessionCookie = cookieStrings.filter({ $0.range(of: "sessionID") != nil }).first {
            let sessionID = "\(sessionCookie)".replacingOccurrences(of: "sessionID=", with: "").trimmingCharacters(in: .whitespaces)
            print("sessionID, sessionID: \(sessionID)")
            return sessionID
        }
        return "123"
    }
    
    var cookieStrings: [String] {
        var result = [String]()
        if headers["cookie"].count > 0 {
            if headers["cookie"].count == 1 && headers["cookie"][0].range(of: ";") != nil {
                let rawCookies = headers["cookie"][0]
                rawCookies.split(separator: ";").forEach { rawCookie in
                    result.append("\(rawCookie)".trimmingCharacters(in: .whitespaces))
                }
            } else {
                //let headersCookie = headers["cookie"]
                //print("cookieStrings headers: \(headersCookie)")
                return headers["cookie"]
            }
        } else {
            //print("cookieStrings headers: \(headers)")
            //print("cookieStrings body: \(body)")
        }
        return result
    }
    
}
