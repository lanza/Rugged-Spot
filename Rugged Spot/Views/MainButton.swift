//
//  MainButton.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/20/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class MainButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
