//
//  LabelCollectionViewCell.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var defaultLabel: BorderedLabel!
    
    var item: Selectable! {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        updateViews()
    }
    
    func updateViews() {
        guard let item = item else { return }
        defaultLabel.text = "\(item.name)"
        if item.isSelected {
            defaultLabel.textColor = UIColor.white
            defaultLabel.backgroundColor = UIColor(named: "mainColor")
        } else {
            defaultLabel.textColor = UIColor.init(named: "mainColor")
            defaultLabel.backgroundColor = UIColor.white
        }
    }
}
