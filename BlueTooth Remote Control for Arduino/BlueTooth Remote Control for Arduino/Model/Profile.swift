//
//  Profile.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 18/12/2021.
//

import Foundation

struct Profile {
    let name: String
    let firstDataName: String
    let secondDataName: String
    var buttonsName: [String]
    let buttonsOrder: [String]
    
    init(from profileEntity : ProfileEntity) {
        self.name = profileEntity.name ?? ""
        self.firstDataName = profileEntity.firstDataName ?? "Data 01"
        self.secondDataName = profileEntity.secondDataName ?? "Data02"
        self.buttonsName = ["","",""]
        self.buttonsName = convertDatasToStringArray(buttonsData: profileEntity.buttonsName)
        self.buttonsOrder = ["","",""]
        //self.buttonsOrder = convertDatasToStringArray(buttonsData: profileEntity.buttonsOrder)
    }
    private func convertDatasToStringArray(buttonsData: Data?) -> [String] {
        guard let datas = buttonsData else { return [] }
            
        let data = Data(datas)
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}

extension Profile: Equatable {
    static func == (lhs: Profile, rhs: ProfileEntity) -> Bool {
        return lhs.name == rhs.name
    }
}
