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
    
    // Premier test fonctionne
    func testLoadProfiles() {
        var loadedProfiles: [Profile] = []
        XCTAssertTrue(loadedProfiles.isEmpty)
        
        let profile = FakeResponse.profiles.first!
        try? profileStorageManager.saveProfile(profile: profile)
        XCTAssertTrue(profile.name == "Name01Test")
        
        do {
            loadedProfiles = try profileStorageManager.loadProfiles()
        } catch {
            XCTFail("Error loading profiles \(error.localizedDescription)")
        }
        XCTAssertFalse(loadedProfiles.isEmpty)
        XCTAssertTrue(loadedProfiles.first?.name == "Name01Test")
    }
    
    func testWhenDeletingOneProfileFromSixThenFiveLeft() {
        var loadedProfiles: [Profile] = []
        
        // Saving recipes from FakeResponse
        for index in 0 ..< FakeResponse.profiles.count {
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
        print(FakeResponse.profiles.count)
        
        XCTAssertTrue(FakeResponse.profiles.count == 6)
        XCTAssertTrue(loadedProfiles.count == 6)
        print(loadedProfiles)
        XCTAssertTrue(loadedProfiles[0].name == "Name02Test")
        
        XCTAssertTrue(loadedProfiles[1].name == "Name04Test")
        
        XCTAssertTrue(loadedProfiles[2].name == "Name06Test")
        
        XCTAssertTrue(loadedProfiles[3].name == "Name01Test")
        
        XCTAssertTrue(loadedProfiles[4].name == "Name03Test")
        
        XCTAssertTrue(loadedProfiles[5].name == "Name05Test")
        
        try? profileStorageManager.deleteProfile(profileToDelete: loadedProfiles[4])
        
        do {
            loadedProfiles = try profileStorageManager.loadProfiles()
        } catch {
            XCTFail("Error loading recipes \(error.localizedDescription)")
        }
        
        XCTAssertTrue(loadedProfiles.count == 5)
        
        XCTAssertTrue(loadedProfiles[0].name == "Name02Test")
        
        XCTAssertTrue(loadedProfiles[1].name == "Name04Test")
        
        XCTAssertTrue(loadedProfiles[2].name == "Name06Test")
        
        XCTAssertTrue(loadedProfiles[3].name == "Name01Test")
        
        XCTAssertTrue(loadedProfiles[4].name == "Name05Test")
    }
}
