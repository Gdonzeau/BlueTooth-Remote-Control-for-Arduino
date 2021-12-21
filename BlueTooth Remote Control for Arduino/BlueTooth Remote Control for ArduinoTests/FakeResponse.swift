//
//  FakeResponse.swift
//  BlueTooth Remote Control for ArduinoTests
//
//  Created by Guillaume Donzeau on 21/12/2021.
//

import Foundation
@testable import BlueTooth_Remote_Control_for_Arduino

class FakeResponse {
    class ProfileError: Error {}
    var error = ProfileError()
    
    static var profileCorrectData: Data {
        let bundle = Bundle(for: FakeResponse.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")!
        return try!  Data(contentsOf: url)
    }
    
    static var profiles: [Profile] {
        let profile01 = Profile(name: "NameTest", datas: "DatasTest")
        let profile02 = Profile(name: "Name02Test", datas: "Datas02Test")
        let profiles = [profile01,profile02]
        /*
        let recipeResponse = try! JSONDecoder().decode(RecipeResponse.self, from: recipeCorrectData)
        return recipeResponse.recipes
 */
        return profiles
    }
    
    static var recipeIncorrectData = "Erreur".data(using: .utf8) // delete
}
