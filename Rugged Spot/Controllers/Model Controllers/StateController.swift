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
        states = [State(name: "Alabama"), State(name: "Alaska"),
                  State(name: "Arizona"), State(name: "Arkansas"), State(name: "California"),
                  State(name: "Colorado"), State(name: "Connecticut"),
                  State(name: "Delaware"), State(name: "Florida"), State(name: "Georgia"),
                  State(name: "Hawaii"), State(name: "Idaho"), State(name: "Illinois"),
                  State(name: "Indiana"), State(name: "Iowa"), State(name: "Kansas"),
                  State(name: "Kentucky"), State(name: "Louisiana"), State(name: "Maine"),
                  State(name: "Maryland"), State(name: "Massachusetts"), State(name: "Michigan"),
                  State(name: "Minnesota"), State(name: "Mississippi"), State(name: "Missouri"),
                  State(name: "Montana"), State(name: "Nebraska"), State(name: "Nevada"),
                  State(name: "New Hampshire"), State(name: "New Jersey"), State(name: "New Mexico"),
                  State(name: "New York"), State(name: "North Carolina"),
                  State(name: "North Dakota"), State(name: "Ohio"), State(name: "Oklahoma"),
                  State(name: "Oregon"), State(name: "Pennsylvania"), State(name: "Rhose Island"),
                  State(name: "South Carolina"), State(name: "South Dekota"),
                  State(name: "Tennessee"), State(name: "Texas"), State(name: "Utah"),
                  State(name: "Vermont"), State(name: "Virginia"), State(name: "Washington"),
                  State(name: "West Virginia"), State(name: "Wisconsin"), State(name: "Wyoming")]
    }
    
    func toggleSelectedFor(state: State) {
        state.isSelected = !state.isSelected
    }
}
