//
//  StyleController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

class StyleController {
    
    // MARK: - Shared Instance
    
    static let shared = StyleController()
    
    // MARK: - Source of Truth
    
    var styles: [Style] = []
    
    private init() {
        styles = ["7s", "10s", "15s", "Super Social"].map { Style(name: $0) }
    }
}
