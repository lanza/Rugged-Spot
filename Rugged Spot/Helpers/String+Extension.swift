//
//  String+Extension.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 1/15/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

extension String {
    // All of the code in this extension is used make the call button function. When you call .makeACall() on a string, it will strip away all punctuation and check to see if the phone number is valid. Use of this allows the user to type in their team's phone number however they want, and allow for proper functionality of the call button
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }

    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter {CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeACall(completion: @escaping ((Bool) -> Void)) {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, completionHandler: completion)
            }
        }
    }
}
