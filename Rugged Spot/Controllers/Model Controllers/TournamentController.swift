//
//  TournamentController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/5/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class TournamentController {
    
    // MARK: - Shared Instance
    
    static let shared = TournamentController()
    
    // MARK: - Properties
    
    var tournaments: [Tournament] = []
    
    var ref: DatabaseReference = Database.database().reference()
    
    // MARK: - Firebase Methods
    
    func fetchAllTournamentsFor(state: State, completion: @escaping ((Bool) -> Void)) {
        self.tournaments = []
        ref.child(state.name).observe(.value) { (snapshot) in
            if let arrayOfDictionaries = snapshot.value as? [String:[String:Any]] {
                arrayOfDictionaries.forEach({ (dictionary) in

                    let name = dictionary.key
                    let state = dictionary.value["state"] as! String
                    let city = dictionary.value["city"] as! String
                    let url = dictionary.value["url"] as! String
                    let arrayOfTypes = dictionary.value["types"] as! [[String:Any]]
                    var types: [TournamentType] = []
                    arrayOfTypes.forEach({ (type) in
                        let newType = TournamentType(dictionary: type)
                        types.append(newType)
                    })

                    let tournament = Tournament(name: name, state: state, city: city, url: url, types: types)
                    self.tournaments.append(tournament)
                })
                completion(true)
                return
            }
            completion(false)
        }
    }
}
