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

    @IBOutlet weak var scrollView: UIScrollView!
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

    // MARK: - Helper Methods

    func setUpViews() {
        // Sets input view for the three text fields to their respective UIPickerView
        stateTextField.inputView = statePickerView
        divisionTextField.inputView = divisionPickerView
        styleTextField.inputView = stylePickerView

        //Adds a done button to each textfield keyboard to resign first responder
        stateTextField.addNextButtonOnKeyboard()
        divisionTextField.addNextButtonOnKeyboard()
        styleTextField.addDoneButtonOnKeyboard()
        
        // Make the font of the SegmentedControl match the rest of the app's font
        let font = UIFont(name: "Avenir Book", size: 18)
        leagueSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
        
        // Add observers for keyboard notifications to give content insets to the scroll view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Sets colors for navBar, search button and segemented control to whatever color is named "mainColor" in the assets folder
    func setUpColors() {
        self.navigationController?.navigationBar.barTintColor = UIColor.init(named: "mainColor")
        leagueSegmentedControl.tintColor = UIColor.init(named: "mainColor")
        searchButton.tintColor = UIColor.init(named: "mainColor")
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
        searchButton.isEnabled = false
        textFieldResignFirstResponders()
        // League defaults to Mens unless selected otherwise
//        var league = "Mens"
//        if leagueSegmentedControl.selectedSegmentIndex == 1 {
//            league = "Womens"
//        }

        // Searches Firebase for the selected parameters.  If search results are found, performs segue, else displays an alert telling the user that no tournaments met the search criteria.
//        TournamentController.shared.fetchTournamentFor(state: state, division: division, style: style, league: league) { (success) in
//            if success {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                self.searchButton.isEnabled = true
//                self.performSegue(withIdentifier: "toResultsController", sender: self)
//            } else {
//                let alertController = UIAlertController(title: "No Tournaments Found", message: "No tournament was found meeting those criterias", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//                self.searchButton.isEnabled = true
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            }
//        }
    }
}

// MARK: - UIPickerView Data Source Methods
extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //Sets the picker to only have one component to select from
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Sets how many rows should be in each picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case statePickerView:
            return StateController.shared.states.count
        case divisionPickerView:
            return DivisionController.shared.divisions.count
        case stylePickerView:
            return StyleController.shared.styles.count
        default:
            return 0
        }
    }

    // MARK: - UIPickerView Delegate Methods

    // Displays the names for each row of the different pickers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case statePickerView:
            return StateController.shared.states[row].name
        case divisionPickerView:
            return DivisionController.shared.divisions[row].name
        case stylePickerView:
            return StyleController.shared.styles[row].name
        default:
            return ""
        }
    }

    // Updates the text field to display the correct index from each array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case statePickerView:
            stateTextField.text = StateController.shared.states[row].name
        case divisionPickerView:
            divisionTextField.text = DivisionController.shared.divisions[row].name
        case stylePickerView:
            styleTextField.text = StyleController.shared.styles[row].name
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
            stateTextField.text = StateController.shared.states[statePickerView.selectedRow(inComponent: 0)].name
        case divisionTextField:
            divisionTextField.text = DivisionController.shared.divisions[divisionPickerView.selectedRow(inComponent: 0)].name
        case styleTextField:
            styleTextField.text = StyleController.shared.styles[stylePickerView.selectedRow(inComponent: 0)].name
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == stateTextField && divisionTextField.text == "" {
            divisionTextField.becomeFirstResponder()
            stateTextField.addDoneButtonOnKeyboard()
        }

        if textField == divisionTextField && styleTextField.text == "" {
            styleTextField.becomeFirstResponder()
            divisionTextField.addDoneButtonOnKeyboard()
        }
    }
}
