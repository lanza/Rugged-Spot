//
//  StateController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation

class StateController {
    // MARK: - Shared Instances
    static let shared = StateController()
    
    // MARK: - Source of Truth
    var states: [State] = []
    
    private init() {
        //Might put this back in if I use a dictionary for tournaments instead of seperate arrays
//        State(name: "None"),
        states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California",
                  "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
                  "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
                  "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
                  "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana",
                  "Nebraska", "Nevada", "New Hampshire", "New Jersey",
                  "New Mexico", "New York", "North Carolina", "North Dakota",
                  "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhose Island",
                  "South Carolina", "South Dekota", "Tennessee", "Texas",
                  "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
                  "Wisconsin", "Wyoming"]
            .map { State(name: $0) }
    }
    
    func toggleSelectedFor(state: State) {
        state.isSelected = !state.isSelected
    }
}
