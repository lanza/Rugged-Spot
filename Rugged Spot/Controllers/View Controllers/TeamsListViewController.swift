//
//  MyTeamsViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 12/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class TeamsListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var defaultViewHiddenConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        checkIfDefaultViewIsNeeded()
    }
    
    
    // MARK: - Helper Methods
    func setUpViews() {
        // Sets the default view on top of the main view if the user has no saved teams
        if TeamController.shared.teams.isEmpty {
            defaultViewHiddenConstraint.priority = UILayoutPriority(rawValue: 850)
            self.view.layoutIfNeeded()
        }
        // Sets the navigation bar to the color named "mainColor"
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "mainColor")
    }
    
    // Animates the default view back top of the main view if the user deletes all their saved teams
    func checkIfDefaultViewIsNeeded() {
        if TeamController.shared.teams.isEmpty {
            defaultViewHiddenConstraint.priority = UILayoutPriority(rawValue: 850)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.defaultViewHiddenConstraint.priority = UILayoutPriority(rawValue: 950)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTeamSegue" {
            guard let index = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? TeamDetailViewController else { return }
            let team = TeamController.shared.teams[index.row]
            destinationVC.team = team
        }
    }
}

// MARK: - UITableView Delegate & Datasource Methods
extension TeamsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamController.shared.teams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        
        let team = TeamController.shared.teams[indexPath.row]
        
        cell.delegate = self
        cell.team = team
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let teamToDelete = TeamController.shared.teams[indexPath.row]
            TeamController.shared.delete(team: teamToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            checkIfDefaultViewIsNeeded()
        }
    }
}

// MARK: - TeanTableViewCell Delegate
extension TeamsListViewController: TeamTableViewCellDelegate {
    func callButtonTapped(_ sender: TeamTableViewCell) {
        sender.team?.phoneNumber?.makeACall()
    }
    
    func websiteButtonTapped(_ sender: TeamTableViewCell) {
        guard let url = URL(string: "\(sender.team!.url!)") else {
            let alertController = UIAlertController(title: "Invalid URL", message: "The URL provided for this team is invalid", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
