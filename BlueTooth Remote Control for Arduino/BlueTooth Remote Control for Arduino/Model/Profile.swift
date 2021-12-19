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
    
    
    init(from profileEntity : ProfileEntity) {
        self.name = profileEntity.name ?? "Save"
        self.datas = profileEntity.datas ?? ""
    }
    init(name:String, datas:String) {
        self.name = name
        self.datas = datas
    }
    /*
    private func convertDatasToStringArray(buttonsName: Data?) -> [String] {
        guard let datas = buttonsName else { return [] }
            
        let data = Data(datas)
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
 */
}

extension Profile: Equatable {
    static func == (lhs: Profile, rhs: ProfileEntity) -> Bool {
        return lhs.name == rhs.name
    }
}
