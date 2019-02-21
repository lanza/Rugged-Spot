//
//  StateSearchViewController.swift
//  Rugged Spot
//
//  Created by Eric Lanza on 2/11/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import FirebaseUI

class StateSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    let storageRef = Storage.storage().reference()
    let placeholderImage = UIImage(named: "tournamentPlaceholder")
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateTextField: PickerTextField!
    @IBOutlet var statePickerView: UIPickerView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets input view for the three text fields to their respective UIPickerView
        statePickerView.selectedRow(inComponent: 0)
        stateTextField.inputView = statePickerView
        stateTextField.addDoneButtonOnKeyboard()
        TournamentController.shared.fetchAllTournaments(for: StateController.shared.states.first!) { (success) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    //     MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tournamentDetailSegue" {
            guard let destionationVC = segue.destination as? TournamentDetailViewController,
                let index = tableView.indexPathForSelectedRow else { return }
            let tournament = TournamentController.shared.tournaments[index.section]
            
            destionationVC.tournament = tournament
            
            if let sender = sender as? TournamentTableViewCell {
                destionationVC.logoImage = sender.teamLogoImageView.image ?? UIImage(named: "tournamentPlaceholder")!
            }
        }
    }
}

extension StateSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TournamentController.shared.tournaments.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }
        
        let tournament = TournamentController.shared.tournaments[indexPath.row]
        
        cell.tournament = tournament
        
        cell.nameLabel.text = tournament.name
        cell.cityLabel.text = "\(tournament.city), \(tournament.state)"
        
        let reference = storageRef.child("\(tournament.state)/\(tournament.name).png")
        cell.teamLogoImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
}

// MARK: - UIPickerView Data Source Methods
extension StateSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //Sets the picker to only have one component to select from
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets how many rows should be in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case statePickerView:
            return StateController.shared.states.count
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
        default:
            return ""
        }
    }
    
    // Updates the text field to display the correct index from each array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case statePickerView:
            let state = StateController.shared.states[row]
            stateTextField.text = state.name
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            TournamentController.shared.fetchAllTournaments(for: state) { (success) in
                if success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                }
            }
        default:
            return
        }
    }
}

// MARK: - UITextFieldDelegates

extension StateSearchViewController: UITextFieldDelegate {
    // Automatically selects the string at the correct index of each array when openning the text field.
    // Mainly used to correctly display data the first time the text field is tapped
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case stateTextField:
            stateTextField.text = StateController.shared.states[statePickerView.selectedRow(inComponent: 0)].name
        default:
            return
        }
    }
}
