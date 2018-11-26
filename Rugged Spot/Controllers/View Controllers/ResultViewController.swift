//
//  ResultViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/6/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    // MARK: - Properties
    
    var state: String = ""
    var division: String = ""
    var style: String = ""
    var league: String = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tournamentTableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = state
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TournamentController.shared.tournaments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }
        
        let tournament = TournamentController.shared.tournaments[indexPath.row]
        
        cell.delegate = self
        cell.url = URL(string: tournament.url) ?? nil
        cell.nameLabel.text = tournament.name
        cell.cityLabel.text = tournament.city
        cell.divisionLabel.text = division
        cell.leagueLabel.text = league
        cell.styleLabel.text = style
        
        return cell
    }
}

extension ResultViewController: TournamentTableViewCellDelegate {
    func websiteButtonTapped(_ sender: TournamentTableViewCell) {
        guard let url = sender.url else {
            
            // If the url is invalid, display alert telling the user.
            let alertController = UIAlertController(title: "Website Invalid", message: "The tournament's website seems to be down, please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        //Open the website in safari
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
