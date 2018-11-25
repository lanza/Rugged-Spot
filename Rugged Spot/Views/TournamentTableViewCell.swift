//
//  TournamentTableViewCell.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/6/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        websiteButton.layer.cornerRadius = 12
        websiteButton.clipsToBounds = true
    }
    
}
