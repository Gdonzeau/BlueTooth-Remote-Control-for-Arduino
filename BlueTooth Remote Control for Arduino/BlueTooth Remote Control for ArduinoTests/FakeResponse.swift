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
    /*
    static var profileCorrectData: Data {
        let bundle = Bundle(for: FakeResponse.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")!
        return try!  Data(contentsOf: url)
    }
    */
    static var profiles: [Profile] {
        let profile01 = Profile(name: "Name01Test", datas: "Datas01Test")
        let profile02 = Profile(name: "Name02Test", datas: "Datas02Test")
        let profile03 = Profile(name: "Name03Test", datas: "Datas03Test")
        let profile04 = Profile(name: "Name04Test", datas: "Datas04Test")
        let profile05 = Profile(name: "Name05Test", datas: "Datas05Test")
        let profile06 = Profile(name: "Name06Test", datas: "Datas06Test")
        let profiles = [profile01,profile02,profile03,profile04,profile05,profile06]
        /*
        let recipeResponse = try! JSONDecoder().decode(RecipeResponse.self, from: recipeCorrectData)
        return recipeResponse.recipes
 */
        return profiles
    }
    
    static var recipeIncorrectData = "Erreur".data(using: .utf8) // delete
}
