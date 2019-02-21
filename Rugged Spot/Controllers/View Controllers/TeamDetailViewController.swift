//
//  TeamDetailViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 12/10/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {

    // MARK: - Properties

    var team: Team?

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
  
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else { return }

        var website = websiteTextField.text

        if website?.prefix(11) == "http://www." {
            website?.insert("s", at: String.Index(encodedOffset: 4))
        } else if website?.prefix(4) == "www." {
            website = "https://" + website!
        } else if website?.prefix(8) == "https://" && website?.prefix(12) != "https://www." {
            website?.insert(contentsOf: "www.", at: String.Index(encodedOffset: 8))
        } else if website?.prefix(7) == "http://" && website?.prefix(11) != "http://www." {
            website?.insert("s", at: String.Index(encodedOffset: 4))
                website?.insert(contentsOf: "www.", at: String.Index(encodedOffset: 8))
        } else if website?.prefix(12) == "https://www." {
            // Had to catch the correct prefix before checking for !=
        } else if website?.prefix(4) != "www.", let websiteTemp = website, !websiteTemp.isEmpty {
            website = "https://www." + websiteTemp
        }
        if let team = team {
            TeamController.shared.update(team: team, withName: name, phoneNumber: phoneNumberTextField.text, url: website)
        } else {
            TeamController.shared.createTeam(withName: name, phoneNumber: phoneNumberTextField.text, url: website)
        }

        self.navigationController?.popViewController(animated: true)
    }

    func setUpViews() {
        // Sets the views up to shows a teams information if the user is editing an exisiting team
        if let team = team {
            nameTextField.text = team.name
            phoneNumberTextField.text = team.phoneNumber
            websiteTextField.text = team.url
        }

        // Adds done button or next to each text field's keyboard to resign first responder
        if team != nil {
            nameTextField.addDoneButtonOnKeyboard()
            phoneNumberTextField.addDoneButtonOnKeyboard()
        } else {
            nameTextField.addNextButtonOnKeyboard()
            phoneNumberTextField.addNextButtonOnKeyboard()
        }
        websiteTextField.addDoneButtonOnKeyboard()
        saveButton.layer.cornerRadius = 5
        saveButton.layer.masksToBounds = true
        
        // Add observers for keyboard notifications to give content insets to the scroll view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Adds content inset to scroll view when kayboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }
    
    // Removes content insets from scroll view when keyboard hides
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension TeamDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField && phoneNumberTextField.text == "" {
            phoneNumberTextField.becomeFirstResponder()
            nameTextField.addDoneButtonOnKeyboard()
        }
        
        if textField == phoneNumberTextField && websiteTextField.text == "" {
            websiteTextField.becomeFirstResponder()
            phoneNumberTextField.addDoneButtonOnKeyboard()
        }
    }
}
