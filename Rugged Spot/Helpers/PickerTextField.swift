//
//  PickerTextField.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/4/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit

class PickerTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}
