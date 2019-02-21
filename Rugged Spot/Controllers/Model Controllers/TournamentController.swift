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

    func fetchAllTournaments(for state: State, completion: @escaping ((Bool) -> Void)) {
        self.tournaments = []
        ref.child(state.name).observe(.value) { snapshot in
            if let dicts = snapshot.value as? [String:[String:Any]] {
                dicts.forEach { key, dict in

                    let name = key
                    let state = dict["state"] as? String
                    let city = dict["city"] as? String
                    let url = dict["url"] as? String
                    let arrayOfTypes = dict["types"] as? [[String:Any]]
                    let types = arrayOfTypes.flatMap { return $0.compactMap { TournamentType(dictionary: $0) } }

                    if let state = state, let city = city, let url = url, let types = types {
                        let tournament = Tournament(name: name, state: state, city: city, url: url, types: types)
                        self.tournaments.append(tournament)
                    }
                }
            }
            completion(true)
            return
        }
        completion(false)
    }
}
