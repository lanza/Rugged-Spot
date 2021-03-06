//
//  ResultViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/6/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import FirebaseUI

class ResultViewController: UIViewController {
    // MARK: - Properties

    var state: String = ""
    var division: String = ""
    var style: String = ""
    var league: String = ""

    let storageRef = Storage.storage().reference()
    let placeholderImage = UIImage(named: "tournamentPlaceholder")
    // MARK: - IBOutlets

    @IBOutlet weak var tournamentTableView: UITableView!
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tournamentDetailSegue" {
            guard let destionationVC = segue.destination as? TournamentDetailViewController,
            let index = tournamentTableView.indexPathForSelectedRow else { return }
            let tournament = TournamentController.shared.tournaments[index.section]
            
            destionationVC.tournament = tournament
            destionationVC.state = state
            destionationVC.style = style
            destionationVC.division = division
            destionationVC.league = league
            if let sender = sender as? TournamentTableViewCell {
                destionationVC.logoImage = sender.teamLogoImageView.image ?? UIImage(named: "tournamentPlaceholder")!
            }
        }
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TournamentController.shared.tournaments.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }

        let tournament = TournamentController.shared.tournaments[indexPath.row]

        cell.tournament = tournament

        cell.nameLabel.text = tournament.name
        cell.cityLabel.text = tournament.city + ", \(state)"

        let reference = storageRef.child("\(state)/\(tournament.name).png")
        cell.teamLogoImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
}
