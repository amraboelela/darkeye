//
//  String.swift
//  Darkeye
//
//  Created by Amr Aboelela on 9/14/22.
//  Copyright © 2022 Amr Aboelela.
//
//

import Foundation

public extension String {

    func htmlWith(searchText: String) -> String {
        var html = self
        let searchTokens = searchText.components(separatedBy: " ")
        for searchToken in searchTokens {
            if let range = html.range(of: searchToken, options: .caseInsensitive) {
                let rangeToken = html[range]
                html = html.replacingOccurrences(of: rangeToken, with: "<b>\(rangeToken)</b>")
            }
        }
        return html
    }
    
}
