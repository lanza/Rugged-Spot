//
//  Selectable.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

protocol Selectable: class {
    var name: String { get }
    var isSelected: Bool { get set }
}

extension Selectable {
    func toggleSelected() {
        self.isSelected = !isSelected
    }
}
