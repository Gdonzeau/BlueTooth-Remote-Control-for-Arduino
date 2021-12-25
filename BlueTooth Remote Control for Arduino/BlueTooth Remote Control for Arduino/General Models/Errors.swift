//
//  Errors.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//

import Foundation
// Different potential errors
//AppErrors
enum AppError: String, LocalizedError {
    case loadingError = "Loading Error."
    case coreDataError = "CoreData Error."
    case errorDelete = "Error while deleting"
    case errorSaving = "Error while saving"
    case nothingIsWritten = "You must write a name"
    case forbiddenCharacters = "Forbidden characters"
    case nameAlreadyExists = "Name exists"
    
    var errorDescription: String? {
        switch self {
        case .coreDataError:
            return "Problème CoreData"
        case .errorDelete:
            return "Problem occured while deleting"
        case .errorSaving:
            return "Problem occured while saving"
        case .nothingIsWritten:
            return "You must give a name."
        case .forbiddenCharacters:
            return "You must not use ':' "
        case .nameAlreadyExists:
            return "This name already exists."
        case .loadingError:
            return "There was an loading error"
        }
    }
    var failureReason: String? {
        switch self {
        case .coreDataError:
            return "Erreur CoreData"
        case .errorDelete:
            return "Did not delete"
        case .errorSaving:
            return "Did not save"
        case .nothingIsWritten:
            return "No name"
        case .forbiddenCharacters:
            return "Forbidden Character used"
        case .nameAlreadyExists:
            return "Name already choosen"
        case .loadingError:
            return "Loading Error"
        }
    }
}

