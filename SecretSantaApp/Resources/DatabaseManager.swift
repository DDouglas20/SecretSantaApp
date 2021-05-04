//
//  DatabaseManager.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    /// Shares the instance of the class instead of having to repeadetly reference the class
    static let shared = DatabaseManager()
    
    public let database = Database.database().reference()
    
    // MARK: Main Functions
    static func firebaseEmail(emailAddress: String) -> String {
        
        /// Allows storage of a user email since Firebase does not allow "."
        let firebaseEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        
        return firebaseEmail
    }
    
    
}

// MARK: Functions for Authentication
extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void) ) {
        
        let firebaseEmail = DatabaseManager.firebaseEmail(emailAddress: email)
        database.child(firebaseEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                print("Could not get value at current node")
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    public func insertUserInfo(withemail email: String, name: String, completion: @escaping ((Bool) -> Void) ){
        database.child(email).setValue([
            "name": name
            
        ], withCompletionBlock: { error, _ in
            
            guard error == nil else {
                print("Failed to insert user's name")
                completion(false)
                return
            }
             completion(true)
        })
        
    }
    
    
}

// MARK: Functions for Inputting or Retrieving Data (Non-Authentication)

extension DatabaseManager {
    
    public func getName(with email: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Could not get data at child path")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public func createGroupID(with email: String, completion: @escaping (Bool) -> Void) {
        
    }
    
}

// MARK: Database Errors
public enum DatabaseError: Error {
    
    case failedToFetch
    
    public var localizedDescription: String {
        switch self {
        case .failedToFetch:
            return "Could not fetch from Database"
        }
    }
}
