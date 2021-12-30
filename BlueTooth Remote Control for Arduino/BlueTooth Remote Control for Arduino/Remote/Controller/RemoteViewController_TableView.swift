//
//  RemoteViewController_TableView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//
import UIKit

extension RemoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableViews
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if tableView == profilesTableView {
            numberOfRows = profiles.count
        }
        if tableView == bluetoothAvailableTableView {
            numberOfRows = peripheralsDetected.count
        }
        return numberOfRows
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 10.0
        
        if tableView == bluetoothAvailableTableView {
            height = 40.0
        }
        
        if tableView == profilesTableView {
            height = 40.0
        }
        
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == profilesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
            cell.textLabel?.text = "\(profiles[indexPath.row].name)"
            return cell
            
        } else if tableView == bluetoothAvailableTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ModuleBT", for: indexPath as IndexPath)
            cell.textLabel?.text = "\(peripheralsDetected[indexPath.row].name)"
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == profilesTableView {
            
            configurationButtons(rank:indexPath.row)
            profileLoaded = profiles[indexPath.row]
            AlternateTableLoadButton(tableShown:false)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if tableView == bluetoothAvailableTableView {
            
            connectBT(peripheral: peripheralsDetected[indexPath.row].peripheral)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    // MARK: - Swipe
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // Swipe action to delete
        
        if tableView == profilesTableView {
            return deleteProfile(row: indexPath.row)
        }
        return UISwipeActionsConfiguration()
        
    }
    
    internal func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == profilesTableView {
            return editProfile(row: indexPath.row)
        }
        return UISwipeActionsConfiguration()
    }
    
    // MARK: - Delete and Edit
    
    private func deleteProfile(row: Int) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            
            let profileToDelete = self.profiles[row]
            
            do {
                // Let's delete
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                }
                completionHandler(true)
            } catch {
                // Error while deleting
                completionHandler(false)
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash")
        
        delete.backgroundColor = .red
        
        // swipe action
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    private func editProfile(row: Int) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            // First : send the profile to edit
            guard let navigationViewController = self.tabBarController?.viewControllers?[1] as? UINavigationController else {
                return
            }
            guard let configurationViewController = navigationViewController.topViewController as? ConfigurationViewController else {
                return
            }
            configurationViewController.profileReceivedToBeLoaded = self.profiles[row]
            
            // Let's delete the profile to edit from Storage
            do {
                try self.profileStorageManager.deleteProfile(profileToDelete: self.profiles[row])
            } catch {
                // Error while deleting
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
            // Reload the TableView of Profiles
            self.profilesTableView.reloadData()
            
            completionHandler(true)
            
            // Let's go to Configuration Tab
            self.tabBarController?.selectedIndex = 1
        }
        edit.image = UIImage(systemName: "book")
        
        edit.backgroundColor = .lightGray
        // swipe action
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
    }
    
}
