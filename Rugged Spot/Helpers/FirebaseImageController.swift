//
//  FirebaseImageController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 1/14/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseImageController {

    let storageRef = Storage.storage().reference()

    func fetchImageFor(tournament: Tournament, completion: @escaping (UIImage?) -> Void) {

    }

}
