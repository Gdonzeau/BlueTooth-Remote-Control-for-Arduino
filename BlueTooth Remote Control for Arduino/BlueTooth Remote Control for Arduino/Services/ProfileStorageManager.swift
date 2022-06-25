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
    
    // MARK: - Load
    
    func loadProfiles() throws -> [Profile] {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        var profilesStored: [ProfileEntity]
        do {
            profilesStored = try viewContext.fetch(request)
        } catch { throw error }
        
        return profilesStored.map { Profile(from: $0) }
    }
    
    // MARK: - Save

    func saveProfile(profile: Profile) throws {
        let profileToSave = ProfileEntity(context: viewContext)
        profileToSave.name = profile.name
        profileToSave.datas = profile.datas
        
        do {
            try viewContext.save()
        } catch { throw error }
    }
    
    // MARK: - Delete

    func deleteProfile(profileToDelete: Profile) throws {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            let response = try viewContext.fetch(request)
            for profile in response {
                if profileToDelete == profile { // Equatable adapted to compare different types
                    viewContext.delete(profile)
                }
            }
            try viewContext.save()
        } catch { throw error }
    }
}
