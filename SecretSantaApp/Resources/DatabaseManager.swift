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
            "",
            "",
            ""
        ]
     */
    
    public func getName(with email: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(email)/name").observe(.value, with: { snapshot in
            guard let value = snapshot.value else {
                print("Could not get data at child path")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    
    public func allowAccessToGroup(groupId: String, email: String) {
        
    }
    
    public func insertIntoGroup(groupID: String) {
        
    }
    
    public func getGroupName(groupID: String, completion: @escaping (Result<String,Error>) -> Void) {
        database.child("Groups/\(groupID)").observe(.value, with: { snapshot in
            guard let data = snapshot.value as? [String: String] else {
                print("Could not get group name")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let groupName = data["groupName"]
            completion(.success(groupName ?? "groupName"))
        })
    }
    
    public func deleteGroupStructure(groupID: String, completion: (Bool) -> Void) {
        // Delete group from database
    }
    
    public func insertGroupStructure(groupStruct: groupStructure, groupID: String, completion: @escaping (Bool) -> Void) {
        guard let memberName = UserDefaults.standard.value(forKey: "name") else {
            print("Could not get memberName")
            return
        }
        
        //var groupDict = [[String: [Any]]]()
        /*groupDict = [
            
            [groupID: [groupStruct.groupName, groupStruct.groupMembers, groupStruct.listOfGifts]]
        
            ]*/
        database.child("Groups/\(groupID)").setValue(groupID, withCompletionBlock: { [weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                completion(false)
                return
            }
            strongSelf.database.child("Groups/\(groupID)/groupName").setValue(groupStruct.groupName, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
            })
            strongSelf.database.child("Groups/\(groupID)/groupMembers").setValue(groupStruct.groupMembers, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
            })
            strongSelf.database.child("Groups/\(groupID)/listOfGifts/\(memberName)").setValue(groupStruct.listOfGifts, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
            })
            completion(true)
        })
    }
    
    public func deleteGroup(email: String, groupName: String, completion: @escaping (Bool) -> Void) {
        database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var value = snapshot.value as? [String] else {
                print("Could not find user's created groups")
                completion(false)
                return
            }
            var x = 0
            for name in value {
                if name == groupName {
                    value[x] = ""
                }
                x += 1
            }
            self?.database.child("\(email)/createdGroups").setValue(value)
            completion(true)
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
    
    public func listenForGroupChanges(email: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard email != "" else {
            print("No current user")
            return
        }
        database.child("\(email)/createdGroups").observe(.value, with: { [weak self] snapshot in
            guard let userData = snapshot.value as? [String] else {
                // Initialize array
                let noCreatedGroupsArr = [
                    "",
                    "",
                    ""
                ]
                self?.database.child("\(email)/createdGroups").setValue(noCreatedGroupsArr, withCompletionBlock: {error, _ in
                    guard error == nil else {
                        print("Could not get updated values")
                        completion(.failure(DatabaseError.noUserCreatedGroups))
                        return
                    }
                })
                
                completion(.success(noCreatedGroupsArr))
                return
            }
            completion(.success(userData))
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
                     "",
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
    
    public func getCreatedGroupsID(email: String, row: Int, completion: @escaping (Result<String,Error>) -> Void) {
        database.child("\(email)/createdGroupsID").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value as? [String] else {
                print("Could not retrieve createdGroupsID")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let groupID = data[row]
            completion(.success(groupID))
            
        })
    }
    
    public func createGroupID(groupName: String, email: String) -> String {
        
        // Get the
        
        let randomInt = String(Int.random(in: 0...1000))
        var easyString = String()
        
        for (index, char) in groupName.enumerated() {
            if index < 3 {
                easyString.append(char)
            }
        }
        
        for (index, char) in email.enumerated() {
            if index < 6 {
                easyString.append(char)
            }
        }
        
        easyString.append(randomInt)
        print("This is easyString: \(easyString)")
        
        return easyString
    }
    
    public func insertGroupID(email: String, groupID: String, groupName: String, completion: @escaping (Bool) -> Void) {
        database.child("\(email)/createdGroupsID").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var value = snapshot.value as? [String] else {
                
                var createdGroupsIDArray = [
                    "",
                    "",
                    ""
                ]
                self?.database.child("\(email)/createdGroupsID").setValue(createdGroupsIDArray, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Could not insert")
                        completion(false)
                        return
                    }
                })
                var arrIndex = 0
                self?.database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { snapshot in
                    guard let createGroups = snapshot.value as? [String] else {
                        print("Error finding groups")
                        completion(false)
                        return
                    }
                    for group in createGroups {
                        print("This is group: \(group)")
                        if group != groupName {
                            arrIndex += 1
                        }
                        else {
                            break
                        }
                    }
                    createdGroupsIDArray[arrIndex].append(groupID)
                    self?.database.child("\(email)/createdGroupsID").setValue(createdGroupsIDArray, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            print("Could not update groupID array valye")
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                })
                
                return
            }
            var arrIndex = 0
            self?.database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { snapshot in
                guard let createGroups = snapshot.value as? [String] else {
                    print("Error finding groups")
                    completion(false)
                    return
                }
                for group in createGroups {
                    if group != groupName {
                        arrIndex += 1
                    }
                    else {
                        break
                    }
                }
                value[arrIndex].append(groupID)
                self?.database.child("\(email)/createdGroupsID").setValue(value, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Could not update groupID array valye")
                        completion(false)
                        return
                    }
                    completion(true)
                })
            })
            
            
        })
    }
    
    public func deleteGroupID(email: String, row: Int, completion: @escaping (Bool) -> Void) {
        let index = row - 1
        database.child("\(email)/createdGroupsID").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var value = snapshot.value as? [String] else {
                print("Could not fetch createdgroupsID")
                completion(false)
                return
            }
            value[index] = ""
            self?.database.child("\(email)/createdGroupsID").setValue(value, withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("Could not update createdGroupsID")
                    completion(false)
                    return
                }
                completion(true)
            })
        })
        
        // Delete groups from /groups
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
