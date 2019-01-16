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

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        teamLogoImageView.clipsToBounds = true
        whiteView.layer.cornerRadius = 5
        whiteView.layer.masksToBounds = true
        shadowView.layer.cornerRadius = 5
    }
}
