//
//  Tournament.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/5/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

struct Tournament: Codable {
    var name: String
    var state: String
    var city: String
    var url: String
    var types: [TournamentType]
}
