//
//  CacheManager.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/7/21.
//

import Foundation

final class CacheManager {
    
    /// Get user's name from cache
    static func getEmailFromCache() -> String {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("User Cache is empty")
            return ""
        }
        return email
    }
    
    static func getNameFromCache() -> String {
        guard let name = UserDefaults.standard.value(forKey: "name") as? String else {
            print("Could cache for key 'name' is empty")
            return ""
        }
        return name
    }
    
}
