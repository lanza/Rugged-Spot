//
//  LeagueController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/20/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

class LeagueController {
    
    static let shared = LeagueController()
    
    var leagues: [League] = []
    
    private init() {
        let mens = League(name: "Mens")
        let womens = League(name: "Womens")
        
        leagues = [mens, womens]
    }
}
