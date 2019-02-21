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
    
    let divisions = ["Premier", "Club", "Open", "Social", "U20", "High School", "College", "Over 35"].map {Division(name: $0) }
}
