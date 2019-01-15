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
    
    func fetchTournamentFor(state: String, division: String, style: String,
                            league: String, completion: @escaping (Bool) -> Void) {
        self.tournaments = []
        ref.child(state).child(division).child(style).child(league).observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                value.forEach({ (dictionary) in
                    let seperatedString = self.seperateCityFrom(string: dictionary.key as! String)
                    let newTournament = Tournament.init(name: seperatedString[0], city: seperatedString[1], url: dictionary.value as! String)
                    self.tournaments.append(newTournament)
                })
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func seperateCityFrom(string: String) -> [String] {
        let firstColon = string.firstIndex(of: ":")
        if firstColon == nil {
            return [string, string]
        }
        let city = String(string[..<firstColon!])
        let name = String(string[firstColon!...]).trimmingCharacters(in: .init(charactersIn: ":"))
        return [name, city]
    }
}
