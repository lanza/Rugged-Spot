//
//  SearchViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 11/5/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var ref: DatabaseReference! = Database.database().reference()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var divisionTextField: UITextField!
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var leagueSegmentedControl: UISegmentedControl!
    @IBOutlet var statePickerView: UIPickerView!
    @IBOutlet var divisionPickerView: UIPickerView!
    @IBOutlet var stylePickerView: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setMultilineTitle()
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        // Sets input view for the three text fields to their respective UIPickerView
        stateTextField.inputView = statePickerView
        divisionTextField.inputView = divisionPickerView
        styleTextField.inputView = stylePickerView
        
        //Adds a done button to each textfield keyboard to resign first responder
        stateTextField.addDoneButtonOnKeyboard()
        divisionTextField.addDoneButtonOnKeyboard()
        styleTextField.addDoneButtonOnKeyboard()
        
        // Makes the search button have rounded edges
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds = true
    }
    
    // Sets colors for navBar, search button and segemented control to whatever color is named "mainColor" in the assets folder
    func setUpColors() {
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "mainColor")
        leagueSegmentedControl.tintColor = UIColor.init(named: "mainColor")
        searchButton.tintColor = UIColor.init(named: "mainColor")
    }
    
    func setMultilineTitle() {
        
        // Adjusts the size of the title's font based on screen size of user's device.
        
        // Default font size
        var fontSize: CGFloat = 40
        if self.view.frame.height <= 650 {
            // Font size for iPhone 5s, SE, and smaller
            fontSize = CGFloat(25)
        } else if self.view.frame.height <= 760 {
            // Font size for iPhone 6, 6s, 7, & 8
            fontSize = CGFloat(30)
        }
        
        // Sets the naviation item's title to hopefully fit the longer title onto one line and not have truncated characters. As a backup, this functions will cause the title to word wrap across multiple lines.
        // If the title changes to something shorter, this function is un-needed
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        self.title = "Search For Tournaments"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]
        
        var count = 0
        for item in(self.navigationController?.navigationBar.subviews)! {
            for sub in item.subviews{
                if sub is UILabel{
                    if count == 1 {
                        break;
                    }
                    let titleLab :UILabel = sub as! UILabel
                    titleLab.numberOfLines = 0
                    titleLab.text = self.title
                    titleLab.lineBreakMode = .byWordWrapping
                    count = count + 1
                }
            }
            
        }
        self.navigationController?.navigationBar.layoutSubviews()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    // Forces whichever text field is open to resignFirstResponder()
    func textFieldResignFirstResponders() {
        stateTextField.resignFirstResponder()
        styleTextField.resignFirstResponder()
        divisionTextField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let state = stateTextField.text, !state.isEmpty,
            let division = divisionTextField.text, !division.isEmpty,
            let style = styleTextField.text, !style.isEmpty else {
                
                // Display missing selection alert if one of the text fields is empty
                let alertController = UIAlertController(title: "Please make sure all fields are filled out", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        textFieldResignFirstResponders()
        // League defaults to Mens unless selected otherwise
        var league = "Mens"
        if leagueSegmentedControl.selectedSegmentIndex == 1 {
            league = "Womens"
        }
        
        // Searches Firebase for the selected parameters.  If search results are found, performs segue, else displays an alert telling the user that no tournaments met the search criteria.
        TournamentController.shared.fetchTournamentFor(state: state, division: division, style: style, league: league) { (success) in
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.performSegue(withIdentifier: "toResultsController", sender: self)
            } else {
                let alertController = UIAlertController(title: "No Tournaments Found", message: "No tournament was found meeting those criterias", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    // MARK: - Navigation
    //Sends the state, style, division, and league information to next viewcontroller to populate each cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultsController" {
            guard let destinationVC = segue.destination as? ResultViewController else { return }
            destinationVC.style = styleTextField.text!
            destinationVC.state = stateTextField.text!
            destinationVC.division = divisionTextField.text!
            if leagueSegmentedControl.selectedSegmentIndex == 0 {
                destinationVC.league = "Mens"
            } else {
                destinationVC.league = "Womens"
            }
        }
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerView Data Source Methods
    
    //Sets the picker to only have one component to select from
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets how many rows should be in each picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case statePickerView:
            return State.states.count
        case divisionPickerView:
            return Division.divisions.count
        case stylePickerView:
            return Style.styles.count
        default:
            return 0
        }
    }
    
    // MARK: - UIPickerView Delegate Methods
    
    // Displays the names for each row of the different pickers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case statePickerView:
            return State.states[row]
        case divisionPickerView:
            return Division.divisions[row]
        case stylePickerView:
            return Style.styles[row]
        default:
            return ""
        }
    }
    
    // Updates the text field to display the correct index from each array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case statePickerView:
            stateTextField.text = State.states[row]
        case divisionPickerView:
            divisionTextField.text = Division.divisions[row]
        case stylePickerView:
            styleTextField.text = Style.styles[row]
        default:
            return
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    // Automatically selects the string at the correct index of each array when openning the text field.
    // Mainly used to correctly display data the first time the text field is tapped
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case stateTextField:
            stateTextField.text = State.states[statePickerView.selectedRow(inComponent: 0)]
        case divisionTextField:
            divisionTextField.text = Division.divisions[divisionPickerView.selectedRow(inComponent: 0)]
        case styleTextField:
            styleTextField.text = Style.styles[stylePickerView.selectedRow(inComponent: 0)]
        default:
            return
        }
    }
}
