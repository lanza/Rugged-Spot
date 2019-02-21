//
//  ShadowView.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 1/14/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

    // This is the subclass for creating shadows around each table view cell. Just set a second view behind a min view inside of a cell and constrain the shadowview to the edges of the main view, and this will create a shadow for the main view.
class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
