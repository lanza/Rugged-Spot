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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var defaultView: UIView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        // Removes any hypens in the phone number text field
//        let phoneNumber = phoneNumberTextField.text?.split(separator: "-")
//
//        // Makes the phone number array from previous line an optional string
//        let phoneNumberAsString = phoneNumber?.joined(separator: "")
        
        // First checks to see if the text pulled from the phone number text field is empty. If not empty, makes sure the phone number is exactly 10 digits long so button works for tap to call function in list view
        
//        if phoneNumberAsString?.count != 0 && phoneNumberAsString?.count != 10 {
//            let phoneNumberAlertController = UIAlertController(title: "Phone number must have exactly 10 digits", message: "Do not include any hyphens, parentheses, or periods", preferredStyle: .alert)
//
//            phoneNumberAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//
//            self.present(phoneNumberAlertController, animated: true, completion: nil)
//            return
//        }
        
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
            TeamController.shared.createTeamWith(name: name, phoneNumber: phoneNumberTextField.text, url: website)
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        // Sets the views up to shows a teams information if the user is editing an exisiting team
        if let team = team {
            nameTextField.text = team.name
            phoneNumberTextField.text = team.phoneNumber
            websiteTextField.text = team.url
            self.title = team.name
        } else {
            
            // Sets the title of the navigation item if the user is adding a new team
            self.title = "Add Your Team"
        }
        
        // Adds done button to each text field's keyboard to resign first responder
        nameTextField.addDoneButtonOnKeyboard()
        phoneNumberTextField.addDoneButtonOnKeyboard()
        websiteTextField.addDoneButtonOnKeyboard()
    }
}
