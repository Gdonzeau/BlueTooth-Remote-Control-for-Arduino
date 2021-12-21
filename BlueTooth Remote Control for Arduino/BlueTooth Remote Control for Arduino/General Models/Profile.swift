//
//  Profile.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 18/12/2021.
//

import Foundation

struct Profile {
    var name: String
    var datas: String
    //var iD: String
    
    
    init(from profileEntity : ProfileEntity) {
        self.name = profileEntity.name ?? "Save"
        self.datas = profileEntity.datas ?? ""
        //self.iD = profileEntity.iD
    }
    
    init(name:String, datas:String) {
        self.name = name
        self.datas = datas
        //self.iD = UUID().uuidString
    }
}

extension Profile: Equatable {
    static func == (lhs: Profile, rhs: ProfileEntity) -> Bool {
        return lhs.name == rhs.name
    }
}
/*
struct User {
var identifier:UUID
var username:String
var email:String
}
*/
/*
class UserFactory {
    func createUser() -> User {
        return User(identifier: UUID(), username: "", email: "")
    }
}
*/
/*
struct User {
var identifier:String

}

let user = User(identifier: UUID().uuidString)
*/
