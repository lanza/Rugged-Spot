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
        styles = [Style(name: "7s"), Style(name: "10s"), Style(name: "15s"), Style(name: "Super Social")]
    }
}
