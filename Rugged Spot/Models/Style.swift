//
//  Style.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/5/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class Style: Selectable {
    var name: String
    var isSelected: Bool
    
    init(name:String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
