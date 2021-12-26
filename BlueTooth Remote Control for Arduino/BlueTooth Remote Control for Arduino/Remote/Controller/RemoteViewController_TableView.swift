//
//  RemoteViewController_TableView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//
import UIKit

extension RemoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    // func numberOfSection not necessary as 1 by default
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // A modifier pour plusieurs sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        //return profiles.count
        /*
         switch section {
         case 0:
         return profiles.count
         case 1:
         return peripheralsDetected.count
         default:
         return 0
         }
         */
        
        if tableView == profilesTableView {
            numberOfRows = profiles.count
        }
        if tableView == bluetoothAvailableTableView {
            numberOfRows = peripheralsDetected.count
        }
        return numberOfRows
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
         let section = indexPath.section
         switch section {
         case 0:
         return 40.0
         case 1:
         return 40.0
         default:
         return 0.0
         }
         
        
        /*
        var height:CGFloat = 10.0
        
        if tableView == bluetoothAvailableTableView {
            height = 40.0
        }
        
        if tableView == profilesTableView {
            height = 40.0
        }
         
         return height
        */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = indexPath.section
        //print(section)
        
        /*
         if tableView == tableBluetooth
         let cell = tableOfProfiles.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(profiles[indexPath.row].name)"
         return cell
         */
        
        /*
         switch section {
         case 0:
         let cell = profilesTableView.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(profiles[indexPath.row].name)"
         return cell
         case 1:
         let cell = bluetoothAvailableTableView.dequeueReusableCell(withIdentifier: "cell_ModuleBT", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(peripheralsDetected[indexPath.row].name)"
         return cell
         default:
         return UITableViewCell()
         }
         */
        
        
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
        print("Touching")
        /*
         let section = indexPath.section
         print(section)
         print("touch \(indexPath.row)")
         configurationButtons(rank:indexPath.row)
         AlternateTableLoadButton(tableShown:false)
         tableView.deselectRow(at: indexPath, animated: true)
         */
        /*
         let section = indexPath.section
         
         switch section {
         case 0:
         print("touch \(indexPath.row)")
         configurationButtons(rank:indexPath.row)
         profileLoaded = profiles[indexPath.row]
         AlternateTableLoadButton(tableShown:false)
         tableView.deselectRow(at: indexPath, animated: true)
         case 1:
         print("BT")
         default:
         print("Oups !")
         }
        */
        
        /*
         print("touch \(indexPath.row)")
         configurationButtons(rank:indexPath.row)
         AlternateTableLoadButton(tableShown:false)
         tableView.deselectRow(at: indexPath, animated: true)
         */
        
        
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
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // Swipe action
        //let section = indexPath.section
        
        if tableView == profilesTableView {// delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            
            let profileToDelete = self.profiles[indexPath.row]
            
            do {
                // Let's delete
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                    //tableView.reloadData()
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
        return UISwipeActionsConfiguration()
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == profilesTableView {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            print("Edit \(indexPath.row)")
            // First : send the profile to edit
            let navVC = self.tabBarController?.viewControllers![1] as! UINavigationController
            let configurationVC = navVC.topViewController as! ConfigurationViewController
            configurationVC.profileReceivedToBeLoaded = self.profiles[indexPath.row]
            
            // Let's delete the profile to edit from Storage
            do {
                try self.profileStorageManager.deleteProfile(profileToDelete: self.profiles[indexPath.row])
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
            self.tabBarController?.selectedIndex = 1
        }
        edit.image = UIImage(systemName: "book")
        
        edit.backgroundColor = .green
        
        // swipe action
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
        }
        return UISwipeActionsConfiguration()
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
