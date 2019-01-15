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

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print(storageRef)
        print(storageRef.child("\(state)"))
    }

}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return TournamentController.shared.tournaments.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }

        let tournament = TournamentController.shared.tournaments[indexPath.section]

        cell.tournament = tournament

        cell.nameLabel.text = tournament.name
        cell.cityLabel.text = tournament.city + ", \(state)"

        let reference = storageRef.child("\(state)/\(tournament.name).png")
        cell.teamLogoImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        return cell
    }
}
