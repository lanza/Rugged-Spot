//
//  State.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/5/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class State: Selectable, Hashable {
    var name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
