//
//  BorderedLabel.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class BorderedLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont(name: "Avenir Book", size: 18)
        self.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
