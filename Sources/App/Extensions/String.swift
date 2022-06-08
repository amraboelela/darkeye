//
//  String.swift
//  DarkEye
//
//  Created by Amr Aboelela on 6/7/22.
//  Copyright © 2022 Amr Aboelela. All rights reserved.
//

import Foundation

public extension String {
    
    // MARK: - Accessors
    
    func base64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
