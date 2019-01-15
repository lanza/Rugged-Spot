//
//  TournamentTableViewCell.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/6/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {

    var tournament: Tournament?

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        teamLogoImageView.clipsToBounds = true
    }
}
