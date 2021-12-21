//
//  BlueTooth_Remote_Control_for_ArduinoTests.swift
//  BlueTooth Remote Control for ArduinoTests
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import XCTest
import CoreData
@testable import BlueTooth_Remote_Control_for_Arduino

class BlueTooth_Remote_Control_for_ArduinoTests: XCTestCase {

    var profileStorageManager: ProfileStorageManager!
    
    let fakeProfiles = FakeProfiles()
    
    override func setUp() {
        super.setUp()
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentStoreDescription.shouldAddStoreAsynchronously = true
        
        let persistentContainer = NSPersistentContainer(name: "BlueTooth_Remote_Control_for_Arduino", managedObjectModel: managedObjectModel)
        
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType, "Store description is not type NSInMemoryStoreType")
            
            if let error = error as NSError? {
                fatalError("Persistent container creation error: \(error), \(error.userInfo)")
            }
        }
        profileStorageManager = ProfileStorageManager(persistentContainer: persistentContainer)
    }
    
    override func tearDown() {
        profileStorageManager = nil
        super.tearDown()
    }
    
    func testSaveProfiles() {
        
        let profile = Profile(name: "LED RC", datas: "Datas to control led")
        try? profileStorageManager.saveProfile(profile: profile)
        
        
        
    }
    // Premier test fonctionne
    func testLoadRecipes() {
        var loadedProfiles: [Profile] = []
        XCTAssertTrue(loadedProfiles.isEmpty)
        
        //let profile = FakeResponse.profiles.first!
        let profile = Profile(name: "LED RC", datas: "Datas to control led")
        try? profileStorageManager.saveProfile(profile: profile)
        XCTAssertTrue(profile.name == "LED RC")
        
        do {
            loadedProfiles = try profileStorageManager.loadProfiles()
        } catch {
            XCTFail("Error loading profiles \(error.localizedDescription)")
        }
        XCTAssertFalse(loadedProfiles.isEmpty)
        XCTAssertTrue(loadedProfiles.first?.name == "LED RC")
    }
    
    func testWhenDeletingOneRecipeFromFiveThenFourLeft() {
        var loadedProfiles: [Profile] = []
        // Saving recipes from Recipes.json
        for index in 0 ..< 5 {
            let profile = FakeResponse.profiles[index]
            try? profileStorageManager.saveProfile(profile: profile)
        }
        // Loading recipes
        XCTAssertTrue(loadedProfiles.count == 0)
        do {
            loadedProfiles = try profileStorageManager.loadProfiles()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedProfiles.count == 5)
        XCTAssertTrue(loadedProfiles[0].name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        
        XCTAssertTrue(loadedProfiles[1].name == "Lemon Salt Lemon Cupcakes")
        
        XCTAssertTrue(loadedProfiles[2].name == "Lemon Icey")
        
        XCTAssertTrue(loadedProfiles[3].name == "Lemon Bars")
        
        XCTAssertTrue(loadedProfiles[4].name == "Lemon Cookies")
        
        try? profileStorageManager.deleteProfile(profileToDelete: loadedProfiles[4])
        
        do {
            loadedProfiles = try profileStorageManager.loadProfiles()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedProfiles.count == 4)
        
        XCTAssertTrue(loadedProfiles[0].name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        
        XCTAssertTrue(loadedProfiles[1].name == "Lemon Salt Lemon Cupcakes")
        
        XCTAssertTrue(loadedProfiles[2].name == "Lemon Icey")
        
        XCTAssertTrue(loadedProfiles[3].name == "Lemon Bars")
    }
}
