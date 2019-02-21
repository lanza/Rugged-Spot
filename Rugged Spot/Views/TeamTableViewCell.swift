//
//  TeamTableViewCell.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 12/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var whiteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        whiteView.layer.cornerRadius = 5
        whiteView.layer.masksToBounds = true
        shadowView.layer.cornerRadius = 5
    }
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!

    weak var delegate: TeamTableViewCellDelegate?

    var team: Team? {
        didSet {
            if team?.phoneNumber == nil || team?.phoneNumber?.count == 0 {
                DispatchQueue.main.async {
                    self.callButton.backgroundColor = UIColor(named: "disabledButtonColor")
                    self.callButton.isEnabled = false
                }
            } else {
                DispatchQueue.main.async {
                    self.callButton.isEnabled = true
                    self.callButton.backgroundColor = UIColor(named: "mainColor")
                }
            }

            // Hides the Website button if the user did not enter a valid website for the team
            if team?.url == nil || team?.url?.count == 0 {
                DispatchQueue.main.async {
                    self.websiteButton.backgroundColor = UIColor(named: "disabledButtonColor")
                    self.websiteButton.isEnabled = false
                }
            } else {
                DispatchQueue.main.async {
                    self.websiteButton.isEnabled = true
                    self.websiteButton.backgroundColor = UIColor(named: "mainColor")
                }
            }
            nameLabel.text = team?.name ?? "Missing Team Name"
        }
    }

    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        delegate?.websiteButtonTapped(self)

    }

    @IBAction func callButtonTapped(_ sender: UIButton) {
        delegate?.callButtonTapped(self)
    }
}

protocol TeamTableViewCellDelegate: class {
    func callButtonTapped(_ sender: TeamTableViewCell)
    func websiteButtonTapped(_ sender: TeamTableViewCell)
}
