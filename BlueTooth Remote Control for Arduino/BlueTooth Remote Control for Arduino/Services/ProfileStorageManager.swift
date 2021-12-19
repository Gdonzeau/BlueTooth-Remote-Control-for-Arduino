//
//  ProfileStorageManagerViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 18/12/2021.
//

import UIKit
import CoreData

class ProfileStorageManager {

    private let viewContext: NSManagedObjectContext
    static let shared = ProfileStorageManager()
    
    init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.viewContext = persistentContainer.viewContext
    }
    
    func loadProfiles() throws -> [Profile] {
        print("Loading")
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        var profilesStored: [ProfileEntity]
        do {
            profilesStored = try viewContext.fetch(request)
        } catch { throw error }
        
        return profilesStored.map { Profile(from: $0) }
    }
    func saveProfile(profile: Profile) throws { // ajouter throws
        print("Saving")
        let profileToSave = ProfileEntity(context: viewContext)
        profileToSave.name = profile.name
        profileToSave.datas = profile.datas
        //profileToSave.datas = try? JSONEncoder().encode(profile.datas)
        
        do {
            try viewContext.save()
            print("Saved : \(String(describing: profileToSave.name))")
       // } catch {  throw error }
        } catch { print("Error \(error)") ; throw error }
    }
    
    func deleteProfile(profileToDelete: Profile) throws { // ajout throws
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            for profile in response {
                if profileToDelete == profile { // Equatable adapted to compare different types
                    viewContext.delete(profile)
                }
            }
            try viewContext.save()
        } catch { print("Error while deleting : \(error)") ; throw error }
    }

}
