//
//  TeamController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 12/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CoreData

class TeamController {
    
    static let shared = TeamController()
    
    private var teams: [Team]? = nil
    init(teams: [Team]? = nil) {
        self.teams = teams
    }
    
    func getTeams() -> [Team] {
        if teams == nil {
            let moc = CoreDataStack.managedObjectContext
            let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
            self.teams = (try? moc.fetch(fetchRequest)) ?? []
        }
        return teams!
    }
    
    func createTeam(withName name: String, phoneNumber: String?, url: String?) {
        let team = Team(name: name, phoneNumber: phoneNumber, url: url)
        teams?.append(team)
        saveToPersistentStore()
    }
    
    func update(team: Team, withName name: String, phoneNumber: String?, url: String?) {
        team.name = name
        team.url = url
        team.phoneNumber = phoneNumber
        saveToPersistentStore()
    }
    
    func delete(team: Team) {
        CoreDataStack.managedObjectContext.delete(team)
        if let teams = teams, let index = teams.index(of: team) {
            self.teams!.remove(at: index)
        }
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch {
            print("Error saving to persistent store: \(error)")
        }
    }
}
