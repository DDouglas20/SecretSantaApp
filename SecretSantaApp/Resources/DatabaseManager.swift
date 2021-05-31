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
    
    public func insertIntoGroup(groupID: String, memberName: String, email: String, completion: @escaping (String) -> Void) {
        
        let memberExists = "memberExists"
        let success = "succcess"
        let databaseError = "error"
        
        database.child("Groups/\(groupID)/groupMembers").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            guard var value = snapshot.value as? [String: String] else {
                completion(databaseError)
                return
            }
            /*for name in value {
                if name == memberName {
                    completion(memberExists)
                    return
                }
            }*/
            if value[memberName] != nil {
                completion(memberExists)
                return
            }
            value[memberName] = email
            strongSelf.database.child("Groups/\(groupID)/groupMembers").setValue(value, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(databaseError)
                    return
                }
                strongSelf.database.child("Groups/\(groupID)/groupName").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                    var groupsDic = [String: String]()
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard let groupName = snapshot.value as? String else {
                        print("Could not get groupName")
                        return
                    }
                    
                    groupsDic[groupName] = groupID
                    print("This is dictionary: \(groupsDic)")
                    strongSelf.database.child("\(email)/joinedGroups").setValue(groupsDic, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(databaseError)
                            return
                        }
                        completion(success)
                    })
                })
            })
        })
        
    }
    
    public func removeCreatedGroup(email: String, groupName: String, completion: @escaping (Bool) -> Void) {
        database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard var dict = snapshot.value as? [String: String] else {
                print("Could not get created groups dict")
                completion(false)
                return
            }
            dict.removeValue(forKey: groupName)
            strongSelf.database.child("\(email)/createdGroups").setValue(dict, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    print("Could not update createdGroupsDict")
                    return
                }
                completion(true)
            })
        })
    }
    
    public func removeAllMembersFromGroup(groupID: String, creatorEmail: String, groupName: String, completion: @escaping (Bool) -> Void) {
        var completionCheck = 1
        database.child("Groups/\(groupID)/groupMembers").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let memberData = snapshot.value as? [String: String] else {
                print("Could not get member data")
                completion(false)
                return
            }
            for key in memberData.keys {
                guard let memberEmail = memberData[key] else {
                    print("Member key was nil")
                    completion(false)
                    return
                }
                print("This is memberEmail: \(memberEmail)")
                if memberEmail == creatorEmail {
                    
                }
                else {
                    strongSelf.database.child("\(memberEmail)/joinedGroups").observeSingleEvent(of: .value, with: { snapshot in
                        guard var dict = snapshot.value as? [String: String] else {
                            print("Could not get members dictionaries")
                            completion(false)
                            return
                        }
                        dict.removeValue(forKey: groupName)
                        strongSelf.database.child("\(memberEmail)/joinedGroups").setValue(dict, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                print("Could not delete from group")
                                completion(false)
                                return
                            }
                        })
                    })
                }
                completionCheck += 1
                if memberData.count == completionCheck {
                    completion(true)
                }
            }
            
        })
        
}
    
    public func deleteFromGroups(groupID: String, completion: @escaping (Bool) -> Void) {
        database.child("Groups/\(groupID)").removeValue(completionBlock: { error, _ in
            guard error == nil else {
                print("Could not delete group")
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func deleteFromCreatedGroups(email: String, completion: @escaping (Bool) -> Void) {
        //database.child("\(email)/createdGroups")
    }
    
    public func leaveGroup(groupId: String, memberName: String, email: String, groupName: String, completion: @escaping (Bool) -> Void) {
        database.child("Groups/\(groupId)/groupMembers").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard var dictionary = snapshot.value as? [String: String] else {
                print("Could not get dictionary from database")
                completion(false)
                return
            }
            dictionary.removeValue(forKey: memberName)
            strongSelf.database.child("Groups/\(groupId)/groupMembers").setValue(dictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                strongSelf.database.child("\(email)/joinedGroups").observeSingleEvent(of: .value, with: { snapshot in
                    guard var joinedDict = snapshot.value as? [String: String] else {
                        print("Could not get joined groups")
                        completion(false)
                        return
                    }
                    joinedDict.removeValue(forKey: groupName)
                    strongSelf.database.child("\(email)/joinedGroups").setValue(joinedDict, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            print("Could not remove group from joinedGroups")
                            return
                        }
                        completion(true)
                    })
                })
            })
        })
    }
    
    public func insertPairs(groupID: String, pairs: [[String: String]], completion: @escaping (Bool) -> Void) {
        database.child("Groups/\(groupID)/pairs").setValue(pairs, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Could not insert pairs")
                return
            }
        })
    }
    
    public func getListofGifts(groupID: String, memberName: String, completion: @escaping (Result<[Any],Error>) -> Void) {
        database.child("Groups/\(groupID)/listOfGifts/\(memberName)").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public func appendGift(groupID: String, items: [Any], memberName: String, completion: @escaping (Bool) -> Void) {
        database.child("Groups/\(groupID)/listOfGifts/\(memberName)").setValue(items, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                print("Could not put gift in array. ")
                return
            }
            completion(true)
        })
    }
    
    public func deleteGift(groupID: String, memberName: String, arrIndex: Int, completion: @escaping (Bool) -> Void) {
        database.child("Groups/\(groupID)/listOfGifts/\(memberName)").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let value = snapshot.value as? [Any] else {
                completion(false)
                return
            }
            var newArray = [Any]()
            newArray = value
            newArray.remove(at: arrIndex)
            strongSelf.database.child("Groups/\(groupID)/listOfGifts/\(memberName)").setValue(newArray, withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("Could not delete item from array")
                    return
                }
                completion(true)
            })
        })
    }
    
    
    
    
    /*
     [test, test2, test3, test4]
     0      1       2       3
     
     */
    
    
    public func createPairs(groupID: String, members: [String], completion: @escaping (Bool) -> Void) {
        var membersCopy = [String]()
        var pairs = [String: String]()
        
        
        membersCopy = members
        // let arrayIteration = membersCopy.count
        for x in membersCopy {
            pairs[x] = ""
        }
        /*for _ in 0..<arrayIteration {
         let randomIndex = Int.random(in: 0..<membersCopy.count)
         let randomMember = membersCopy[randomIndex]
         
         }*/
        for x in membersCopy {
            let randomIndex = Int.random(in: 0..<membersCopy.count)
            let randomMember = membersCopy[randomIndex]
            if x != randomMember  {
                pairs[x] = randomMember
                membersCopy.remove(at: randomIndex)
            }
            else {
                membersCopy.append(randomMember)
                membersCopy.remove(at: randomIndex)
            }
        }
        print("These are the pairs of members: \(pairs)")
        
        database.child("Groups/\(groupID)/GroupPairs").setValue(pairs, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Could not put pairs into the database")
                completion(false)
                return
            }
        })
        
        
    }
    
    public func getPairs(groupID: String, completion: @escaping (Result<[String: String],Error>) -> Void) {
        database.child("Groups/\(groupID)/pairs").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: String] else {
                print("Could not get pairs")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public func getGroupName(groupID: String, completion: @escaping (Result<String,Error>) -> Void) {
        database.child("Groups/\(groupID)/groupName").observe(.value, with: { snapshot in
            guard let data = snapshot.value as? String else {
                print("Could not get group name")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let groupName = data
            completion(.success(groupName))
        })
    }
    
    public func getGroupMembers(groupID: String, completion: @escaping (Result<[String],Error>) -> Void) {
        var arrOfMembers = [String]()
        
        database.child("Groups/\(groupID)/groupMembers").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value as? [String: String] else {
                print("Coudl not get group memebers")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            for key in data.keys {
                arrOfMembers.append(key)
            }
            completion(.success(arrOfMembers))
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
    
    public func deleteCreatedGroup(email: String, groupName: String, completion: @escaping (Bool) -> Void) {
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
    
    public func createGroupDict(dict: [String: String], email: String, completion: @escaping (Bool) -> Void) {
        database.child("\(email)/createdGroups").setValue(dict, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
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
    
    public func listenForCreatedGroupChangesDict(email: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        database.child("\(email)/createdGroups").observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let groupsDict = snapshot.value as? [String: String] else {
                // Initialize Array
                let newDict = [String: String]()
                strongSelf.database.child("\(email)/createdGroups").setValue(newDict, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Could not update createdGroups")
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    completion(.success(newDict))
                })
               return
            }
            
            completion(.success(groupsDict))
            
        })
    }
    
    /*public func listenForCreatedGroupChanges(email: String, completion: @escaping (Result<[String], Error>) -> Void) {
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
    }*/
    
    public func listenForJoinedGroupChanges(email: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        database.child("\(email)/joinedGroups").observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let value = snapshot.value as? [String: String] else {
                // Initialize Array
                let newJoinedGroupsArr = [String: String]()
                strongSelf.database.child("\(email)/joinedGroups").setValue(newJoinedGroupsArr, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Could not set the value of joinedGroups")
                        completion(.failure(DatabaseError.failedToFetch))
                        return
                    }
                    completion(.success(newJoinedGroupsArr))
                })
                return
            }
            
            completion(.success(value))
        })
    }
    
    public func getJoinedGroupID(email: String, groupName: String, completion: @escaping (Result<String, Error>) -> Void) {
        database.child("\(email)/joinedGroups").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard let dictionary = snapshot.value as? [String: String] else {
                print("Could not get joinedGroups Dictionary")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            guard let groupID = dictionary[groupName] else {
                print("Key has no value")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(groupID))
            
        })
    }
    
    public func getCreatedGroupsDict(email: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String: String] else {
                // Initialize a new dict
                print("Could not find any groups so creating a new one")
                let newDict = [String: String]()
                completion(.success(newDict))
                return
            }
            completion(.success(dict))
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
    
    public func getCreatedGroupsID(email: String, groupName: String, completion: @escaping (Result<String,Error>) -> Void) {
        database.child("\(email)/createdGroups").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value as? [String: String] else {
                print("Could not retrieve createdGroupsID")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            guard let groupID = data[groupName] else {
                print("Could not get groupID")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
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
