//
//  FilteredSearchViewController.swift
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

class FilteredSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isFiltering: Bool = false
    private let storageRef = Storage.storage().reference()
    private let placeholderImage = UIImage(named: "tournamentPlaceholder")
    private var selectedDivision: Division?
    private var selectedDivisionIndexPath: IndexPath?
    private var selectedStyle: Style?
    private var selectedStyleIndexPath: IndexPath?
    private var selectedLeague: League?
    private var filteredTournaments: [Tournament] {
        
        var returnTournaments = TournamentController.shared.tournaments
        
        if let selectedDivision = selectedDivision {
            returnTournaments = filter(tournaments: returnTournaments, by: selectedDivision)
        }
        
        if let selectedStyle = selectedStyle {
            returnTournaments = filter(tournaments: returnTournaments, by: selectedStyle)
        }
        
        if let selectedLeague = selectedLeague {
            returnTournaments = filter(tournaments: returnTournaments, by: selectedLeague)
        }
        
        return returnTournaments
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var divisionCollectionView: UICollectionView!
    @IBOutlet weak var styleCollectionView: UICollectionView!
    @IBOutlet weak var leagueCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deselectFilters()
    }
    
    // MARK: - Helper Methods
    /*
    When the device is rotated, this function will scroll to whatever the currently selected filter is for each collection view, and reload the views.
     Without this function, the font color of each selected collection view defaults to "mainColor" and the backgroundColor stays as "mainColor" causing the text to disappear.
    */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            DispatchQueue.main.async {
                self.divisionCollectionView.scrollToItem(at: self.selectedDivisionIndexPath ?? IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                self.styleCollectionView.scrollToItem(at: self.selectedStyleIndexPath ?? IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                self.divisionCollectionView.reloadData()
                self.leagueCollectionView.reloadData()
                self.styleCollectionView.reloadData()
            }
        }, completion: nil)
    }
    
    
    /// Checks to see if filtering is needed based on the selected types.  If no labels are selected, filtering will turn off and all tournaments for that state will show.
    func checkForFiltering() {
        if selectedLeague == nil && selectedStyle == nil && selectedDivision == nil {
            isFiltering = false
        } else {
            isFiltering = true
        }
    }
    
    /// Filters an array of tournaments (usually from the TournamentController) based on the a class type that conforms to the "Selectable" protocol. Currently supports the types: `Division`, `Style`, and `League`.
    ///
    /// - Parameters:
    ///   - tournaments: Array of tournaments to filter
    ///   - selectable: How the tournament will be filtered
    /// - Returns: Filtered array of tournaments based on selectable parameter
    func filter(tournaments: [Tournament], by selectable: Selectable) -> [Tournament] {
        if let division = selectable as? Division {
            let returnTournaments = tournaments.filter { $0.types.contains { $0.division == division.name} }
            return returnTournaments
        }
        
        if let style = selectable as? Style {
            let returnTournaments = tournaments.filter { $0.types.contains { $0.style == style.name} }
            return returnTournaments
        }
        
        if let league = selectable as? League {
            let returnTournaments = tournaments.filter { $0.types.contains { $0.league == league.name} }
            return returnTournaments
        }
        return []
    }
    
    
    /// Turns off all filters. Called in ViewDidDisappear to stop old filters from persisting after the view closes
    func deselectFilters() {
        selectedDivision?.isSelected = false
        selectedLeague?.isSelected = false
        selectedStyle?.isSelected = false
    }
    
    /// Toggles to show or hide the `EmptyView` depending if the current filters have any matching tournaments or not
    func toggleEmptyView() {
        if filteredTournaments.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    // MARK: - Navigation
    
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

// MARK: - Collection View Delegate & Data Source Methods

extension FilteredSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case divisionCollectionView:
            return DivisionController.shared.divisions.count
        case styleCollectionView:
            return StyleController.shared.styles.count
        case leagueCollectionView:
            return LeagueController.shared.leagues.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? LabelCollectionViewCell
        let item: Selectable?
        
        switch collectionView {
        case divisionCollectionView:
            item = DivisionController.shared.divisions[indexPath.row]
        case styleCollectionView:
            item = StyleController.shared.styles[indexPath.row]
        case leagueCollectionView:
            item = LeagueController.shared.leagues[indexPath.row]
        default:
            return UICollectionViewCell()
        }
        
        cell?.defaultLabel.text = item?.name
        cell?.item = item
        
        return cell ?? UICollectionViewCell()
    }
    
    /*
     Toggles each of the labels in any collection view. Calls for a table reload after a filter is added to call the `filteredTournaments` computed property.
     Also sets the selected index path for either division or style.  Selected index path is used when rotating the device so scroll the collection view to the correct index path.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LabelCollectionViewCell
        
        cell.item!.toggleSelected()
        
        switch collectionView {
        case divisionCollectionView:
            if selectedDivision?.name != cell.item!.name {
                selectedDivision?.toggleSelected()
                selectedDivision = (cell.item as! Division)
                selectedDivisionIndexPath = indexPath
            } else {
                selectedDivision = nil
                selectedDivisionIndexPath = nil
            }
            divisionCollectionView.reloadData()
        case styleCollectionView:
            if selectedStyle?.name != cell.item!.name {
                selectedStyle?.toggleSelected()
                selectedStyle = (cell.item as! Style)
                selectedStyleIndexPath = indexPath
            } else {
                selectedStyle = nil
                selectedStyleIndexPath = nil
            }
            styleCollectionView.reloadData()
        case leagueCollectionView:
            if selectedLeague?.name != cell.item!.name {
                selectedLeague?.toggleSelected()
                selectedLeague = (cell.item as! League)
            } else {
                selectedLeague = nil
            }
            leagueCollectionView.reloadData()
        default:
            return
        }
        
        checkForFiltering()
        tableView.reloadData()
        toggleEmptyView()
    }
}

// MARK: - Collection View Delegate Flow Laylout Methods

extension FilteredSearchViewController: UICollectionViewDelegateFlowLayout {
    
    // Sets the collection view cells to all be the same size and fit the largest label content
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 26)
    }
}

// MARK: - UITableView Datasource & Delegate Methods

extension FilteredSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTournaments.count
        } else {
            return TournamentController.shared.tournaments.count
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as? TournamentTableViewCell else { return UITableViewCell() }
        
        var tournament = TournamentController.shared.tournaments[indexPath.row]
        
        if isFiltering {
            tournament = filteredTournaments[indexPath.row]
        }
        
        cell.tournament = tournament
        
        cell.nameLabel.text = tournament.name
        cell.cityLabel.text = "\(tournament.city), \(tournament.state)"
        
        let reference = storageRef.child("\(tournament.state)/\(tournament.name).png")
        cell.teamLogoImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
}
