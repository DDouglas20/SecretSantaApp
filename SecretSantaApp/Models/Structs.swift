//
//  Structs.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/3/21.
//

import Foundation
import UIKit

struct SecretSantaUser {
    let name: String
    let emailAddress: String
    
    var firebaseEmail: String {
        return DatabaseManager.firebaseEmail(emailAddress: emailAddress)
    }
    
    var profilePictureFilename: String {
        return "Placeholder"
    }
}

