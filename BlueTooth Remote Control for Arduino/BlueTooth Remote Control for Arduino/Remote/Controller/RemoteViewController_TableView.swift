//
//  RemoteViewController_TableView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//
import UIKit

extension RemoteViewController: UITableViewDataSource {
    
    // func numberOfSection not necessary as 1 by default
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // A modifier pour plusieurs sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  if tableView == tableOfProfiles {
       // switch section
        return profiles.count
       // } else if
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        //switch section
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel?.text = "\(profiles[indexPath.row].name)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touch \(indexPath.row)")
        configurationButtons(rank:indexPath.row)
        AlternateTableLoadButton(tableShown:false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RemoteViewController: UITableViewDelegate {
    
    private func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) throws -> UISwipeActionsConfiguration? { // Swipe action
        /*
        guard recipeMode == .database else {
            return nil
        }
        */
        let editingAction = UIContextualAction(
            style: .normal, title: "Edit") { _, _, completionHandler in
            let profileToEdit = self.profiles[indexPath.row]
            
            do {
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToEdit)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                }
                completionHandler(true)
            } catch {
                print("Error while deleting")
                completionHandler(false)
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
        
        let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { _, _, completionHandler in
            let profileToDelete = self.profiles[indexPath.row]
            
            do {
                print("On efface")
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                }
                completionHandler(true)
            } catch {
                print("Error while deleting")
                completionHandler(false)
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [editingAction,deleteAction])
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        /*
        if editingStyle == .delete {
            
            let deleteAction = UIContextualAction(
                style: .destructive, title: "Delete") { _, _, completionHandler in
                let profileToDelete = self.profiles[indexPath.row]
                
                do {
                    try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                    DispatchQueue.main.async {
                        self.getProfilesFromDatabase()
                    }
                    completionHandler(true)
                } catch {
                    print("Error while deleting")
                    completionHandler(false)
                    let error = AppError.errorDelete
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                }
            }
            
            //profilesName.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .bottom)
        }
        if editingStyle == .insert {
        }
 */
    }
}
