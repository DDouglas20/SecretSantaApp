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
    
    /*
     Database storage method:
        Groups: [
            group1: groupID -> "\(encryptedEmail)" + "1"
            group1Name: someString
            group2: groupID
            group2Name: someString
            etc...
        ]
     */
    
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
    
    public func createGroup(array: [String], email: String, completion: @escaping (Bool) -> Void) {
        database.child("\(email)/createdGroups").setValue(array, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func getCreatedGroups(with email: String, completion: @escaping (Result<[String], Error>) -> Void) {
        database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let userData = snapshot.value as? [String] {
                completion(.success(userData))
                return
            }
            else {
                // initializes branch in database
                let noCreatedGroupsArr = [
                     "testing",
                     "",
                     ""
                ]
                
                self?.database.child("\(email)/createdGroups").setValue(noCreatedGroupsArr, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Failed to insert new user Array")
                        completion(.failure(DatabaseError.noUserCreatedGroups))
                        return
                    }
                    completion(.success(noCreatedGroupsArr))
                })
                
            }
        })
        
    }
    
    public func createGroupID(groupName: String, email: String) -> String {
        
        // Get the
        
        let randomInt = String(Int.random(in: 0...100))
        var easyString = String()
        
        for (index, char) in groupName.enumerated() {
            if index < 3 {
                easyString.append(char)
            }
        }
        
        for (index, char) in email.enumerated() {
            if index < 3 {
                easyString.append(char)
            }
        }
        
        easyString.append(randomInt)
        print("This is easyString: \(easyString)")
        
        return easyString
    }
    
    public func createLowercase(email: String) {
        
    }
    
}

// MARK: Database enums
public enum encryptedEmail: String {
    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
    
    public var numberEncryption: Int {
        switch self {
        
        case .a:
            return 1
        case .b:
            return 2
        case .c:
            return 3
        case .d:
            return 4
        case .e:
            return 5
        case .f:
            return 6
        case .g:
            return 7
        case .h:
            return 8
        case .i:
            return 9
        case .j:
            return 10
        case .k:
            return 11
        case .l:
            return 12
        case .m:
            return 13
        case .n:
            return 14
        case .o:
            return 15
        case .p:
            return 16
        case .q:
            return 17
        case .r:
            return 18
        case .s:
            return 19
        case .t:
            return 20
        case .u:
            return 21
        case .v:
            return 22
        case .w:
           return 23
        case .x:
            return 24
        case .y:
            return 25
        case .z:
            return 26
        }
    }
    
}

// MARK: Database Errors
public enum DatabaseError: Error {
    
    case failedToFetch
    case noUserCreatedGroups
    
    public var localizedDescription: String {
        switch self {
        case .failedToFetch:
            return "Could not fetch from Database"
        case .noUserCreatedGroups:
            return "Could not create or retrieve user created groups"
        }
        
    }
    
}
