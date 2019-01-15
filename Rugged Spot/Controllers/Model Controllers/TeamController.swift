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

    var teams: [Team] {
        let moc = CoreDataStack.managedObjectContext

        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()

        let results = try? moc.fetch(fetchRequest)

        return results ?? []
    }

    func createTeamWith(name: String, phoneNumber: String?, url: String?) {
        _ = Team(name: name, phoneNumber: phoneNumber, url: url)
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
