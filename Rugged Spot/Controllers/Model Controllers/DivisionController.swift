//
//  DivisionController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

class DivisionController {
    
    // MARK: - Shared Instance
    
    static let shared = DivisionController()
    
    // MARK: - Source of Truth
    
    var divisions: [Division] = []
    
    private init() {
        divisions = [ Division(name:"Premier"), Division(name:"Club"), Division(name:"Open"), Division(name:"Social"), Division(name:"U20"), Division(name:"High School"), Division(name:"College"), Division(name:"Over 35"), Division(name:"Old Boys")]
        
    }
    
}
