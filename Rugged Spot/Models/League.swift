//
//  League.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/20/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

class League {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
