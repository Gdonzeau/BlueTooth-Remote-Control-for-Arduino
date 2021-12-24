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
        //  if tableView == tableOfProfiles {
        // switch section
        
        // } else if
        if tableView == tableOfProfiles {
            numberOfRows = profiles.count
        }
        if tableView == tableBluetooth {
            print("Row") // S'imprime
            numberOfRows = peripheralsDetected.count
        }
        return numberOfRows
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 10.0
        
        if tableView == tableBluetooth {
            print("Height") // Ne s'imprime pas
            height = 20.0
        }
        
        if tableView == tableOfProfiles {
            print("Hauteur") // S'imprime
            height = 30.0
        }
        
        
        /*
         let section = indexPath.section
         switch section {
         case 0:
         return 60.0
         case 1:
         return 32.0
         default:
         return 0.0
         }
         */
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        print(section)
        
        /*
         if tableView == tableBluetooth
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(profiles[indexPath.row].name)"
         return cell
         */
        /*
         switch section {
         case 0:
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(profiles[indexPath.row].name)"
         return cell
         case 1:
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ModuleBT", for: indexPath as IndexPath)
         cell.textLabel?.text = "\(peripheralsDetected[indexPath.row].name)"
         return cell
         default:
         return UITableViewCell()
         }
         */
        if tableView == tableOfProfiles {
            print("TableProfile")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Profile", for: indexPath as IndexPath)
            cell.textLabel?.text = "\(profiles[indexPath.row].name)"
            return cell
        } else if tableView == tableBluetooth {
            print("TableBluetooth")
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
         AlternateTableLoadButton(tableShown:false)
         tableView.deselectRow(at: indexPath, animated: true)
         case 1:
         print("BT")
         default:
         print("Oups !")
         }
         print("touch \(indexPath.row)")
         configurationButtons(rank:indexPath.row)
         AlternateTableLoadButton(tableShown:false)
         tableView.deselectRow(at: indexPath, animated: true)
         */
        if tableView == tableOfProfiles {
            
            print("touch0 \(indexPath.row)")
            configurationButtons(rank:indexPath.row)
            profileLoaded = profiles[indexPath.row]
            AlternateTableLoadButton(tableShown:false)
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else { //if tableView == tableBluetooth {
            print("touch1 \(indexPath.row)")
            //configurationButtons(rank:indexPath.row)
            //AlternateTableLoadButton(tableShown:false)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // Swipe action
        print("swipeFR \(indexPath.row)")
        /*
         guard recipeMode == .database else {
         return nil
         }
         */
        // delete
        let delete = UIContextualAction(style: .normal, title: "Efface") { (action, view, completionHandler) in
            print("Efface \(indexPath.row)")
            
            let profileToDelete = self.profiles[indexPath.row]
            
            do {
                print("On efface")
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                    tableView.reloadData()
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
            
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash")
        
        delete.backgroundColor = .red
        
        // edit
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            print("Edit \(indexPath.row)")
            
            let navVC = self.tabBarController?.viewControllers![1] as! UINavigationController
            let configurationVC = navVC.topViewController as! ConfigurationViewController
            configurationVC.test = self.test
            configurationVC.profileReceivedToBeLoaded = self.profiles[indexPath.row]
            
            completionHandler(true)
            self.tabBarController?.selectedIndex = 1
        }
        edit.image = UIImage(systemName: "book")
        
        edit.backgroundColor = .green
        
        // delete
        let share = UIContextualAction(style: .normal, title: "Share") { (action, view, completionHandler) in
            print("Efface \(indexPath.row)")
            completionHandler(true)
        }
        share.image = UIImage(systemName: "square.and.arrow.up")
        
        share.backgroundColor = .orange
        
        // swipe action
        let swipe = UISwipeActionsConfiguration(actions: [delete,edit,share])
        return swipe
        
        
        
        /*
         let editingAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
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
         */
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("swipeFL \(indexPath.row)")
        /*
         guard recipeMode == .database else {
         return nil
         }
         */
        // delete
        let delete = UIContextualAction(style: .normal, title: "Efface") { (action, view, completionHandler) in
            print("Efface \(indexPath.row)")
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash")
        
        delete.backgroundColor = .red
        
        // edit
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            print("Edit \(indexPath.row)")
            completionHandler(true)
        }
        edit.image = UIImage(systemName: "book")
        
        edit.backgroundColor = .green
        
        // delete
        let share = UIContextualAction(style: .normal, title: "Share") { (action, view, completionHandler) in
            print("Efface \(indexPath.row)")
            completionHandler(true)
        }
        share.image = UIImage(systemName: "square.and.arrow.up")
        
        share.backgroundColor = .orange
        
        // swipe action
        let swipe = UISwipeActionsConfiguration(actions: [delete,edit,share])
        return swipe
        
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
