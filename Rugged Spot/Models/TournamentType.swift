//
//  TournamentType.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/13/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

struct TournamentType: Codable {
    let division: String?
    let style: String?
    let league: String?
    
    init(division: String, style: String, league: String) {
        self.division = division
        self.style = style
        self.league = league
    }
    
    init?(dictionary: [String: Any]) {
        let division = dictionary["division"] as? String
        let style = dictionary["style"] as? String
        let league = dictionary["league"] as? String
        
        if let d = division, let s = style, let l = league {
            self.init(division: d, style: s, league: l)
        } else {
            return nil
        }
    }
}
