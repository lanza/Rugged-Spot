//
//  TournamentDetailViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 1/15/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class TournamentDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var tournament: Tournament?
    var logoImage: UIImage = UIImage(named: "tournamentPlaceholder")!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    
    // MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    
    // Opens whatever the tournaments website is when the "Visit Website" button is tapped
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        self.websiteButton.isEnabled = false
        if let urlString = tournament?.url, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url) { (_) in
                self.websiteButton.isEnabled = true
            }
        }
    }
    
    // Sets the views for each UIelement inside of the view controller
    func setUpViews() {
        guard let tournament = tournament else { return }
        nameLabel.text = tournament.name
        cityLabel.text = "City: \(tournament.city)"
        stateLabel.text = "State: \(tournament.state)"
        logoImageView.image = logoImage
    }
}
