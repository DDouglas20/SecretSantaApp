//
//  CreateGroupViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/7/21.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    //MARK: Class Variables
    private let email = CacheManager.getEmailFromCache()
    
    private var groupID = String()
    
    private let memberName = CacheManager.getNameFromCache()
    
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.text = "________________________________"
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    private let fieldLabel2: UILabel = {
        let label = UILabel()
        label.text = "________________________________"
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    private let groupNameField: UITextField = {
        let groupField = UITextField()
        groupField.backgroundColor = .black
        groupField.attributedPlaceholder = NSAttributedString(string: "Group Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        groupField.autocapitalizationType = .words
        groupField.returnKeyType = .done
        groupField.autocorrectionType = .no
        groupField.textColor = .white
        
        return groupField
    }()
    
    private let joinGroupField: UITextField = {
        let joinField = UITextField()
        joinField.backgroundColor = .black
        joinField.attributedPlaceholder = NSAttributedString(string: "Paste Group ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        joinField.autocapitalizationType = .allCharacters
        joinField.returnKeyType = .done
        joinField.autocorrectionType = .no
        joinField.textColor = .white
        
        return joinField
    }()
    
    private let createGroupLabel: UILabel = {
        let createLabel = UILabel()
        createLabel.text = "Create a Group: "
        createLabel.textColor = .white
        createLabel.font = .boldSystemFont(ofSize: 25)
        createLabel.textAlignment = .left
        //createLabel.attributedText = NSAttributedString(string: string, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single])
        
        
        return createLabel
    }()
    
    private let joinGroupLabel: UILabel = {
        let joinLabel = UILabel()
        joinLabel.text = "Join a Group: "
        joinLabel.textColor = .white
        joinLabel.font = .boldSystemFont(ofSize: 25)
        joinLabel.textAlignment = .left
        
        return joinLabel
    }()
    
    private let createGroupButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .systemGreen
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 6
        createButton.layer.borderWidth = 1
        
        return createButton
    }()
    
    private let joinGroupButton: UIButton = {
        let joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.backgroundColor = .systemRed
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 6
        joinButton.layer.borderWidth = 1
        
        return joinButton
    }()

    
    // MARK: UI View Code
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameField.delegate = self
        joinGroupField.delegate = self
        
        // Add Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(groupNameField)
        scrollView.addSubview(joinGroupField)
        scrollView.addSubview(createGroupLabel)
        scrollView.addSubview(joinGroupLabel)
        scrollView.addSubview(createGroupButton)
        scrollView.addSubview(joinGroupButton)
        scrollView.addSubview(fieldLabel)
        scrollView.addSubview(fieldLabel2)
        
        // Button Actions
        createGroupButton.addTarget(self,
                                    action: #selector(createButtonTapped),
                                    for: .touchUpInside)
        joinGroupButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        createGroupLabel.frame = CGRect(x: 5,
                                        y: 100,
                                        width: scrollView.width,
                                        height: 50)
        groupNameField.frame = CGRect(x: 5,
                                      y: createGroupLabel.bottom + 5,
                                      width: scrollView.width,
                                      height: 50)
        fieldLabel.frame = CGRect(x: 5,
                                  y: groupNameField.bottom - 40,
                                  width: scrollView.width,
                                  height: 50)
        createGroupButton.frame = CGRect(x: (scrollView.width/2) - ((scrollView.width-200)/2),
                                         y: fieldLabel.bottom + 5,
                                         width: scrollView.width - 200,
                                         height: 50)
        joinGroupLabel.frame = CGRect(x: 5,
                                      y: createGroupButton.bottom + 10,
                                      width: scrollView.width,
                                      height: 50)
        joinGroupField.frame = CGRect(x: 5,
                                      y: joinGroupLabel.bottom + 5,
                                      width: scrollView.width,
                                      height: 50)
        fieldLabel2.frame = CGRect(x: 5,
                                   y: joinGroupField.bottom - 40,
                                   width: scrollView.width,
                                   height: 50)
        joinGroupButton.frame = CGRect(x: (scrollView.width/2) - ((scrollView.width-200)/2),
                                       y: joinGroupField.bottom + 5,
                                       width: scrollView.width - 200,
                                       height: 50)
        
    }
    
    //MARK: Class functions
    
    private func createGroupStruct(groupName: String, completion: @escaping (Result<groupStructure,Error>) -> Void) {
        var name = String()
        DatabaseManager.shared.getName(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let userData = data as? String else {
                    print("This is data: \(data)")
                    print("Could not get name from database")
                    return
                }
                name = userData
            case .failure(let error):
                print("Could not get name: \(error)")
                completion(.failure(DatabaseError.failedToFetch))
                
            }
            print("This is name: \(name)")
            let groupStruct = groupStructure(groupName: groupName, groupMembers: [name: strongSelf.email], listOfGifts: [""])
            completion(.success(groupStruct))
        })
        
        
    }
    
    @objc private func createButtonTapped() {
        // unwrap
        guard let groupName = groupNameField.text,
              !groupName.isEmpty else {
                return
        }
        DatabaseManager.shared.getCreatedGroupsDict(email: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            var newDict = [String: String]()
            switch result {
            case .success(let dict):
                if dict.count >= 10 {
                    strongSelf.maxRoomsCreated()
                    return
                }
                newDict = dict
                let groupID = DatabaseManager.shared.createGroupID(groupName: groupName, email: strongSelf.email)
                newDict[groupName] = groupID
                DatabaseManager.shared.createGroupDict(dict: newDict, email: strongSelf.email, completion: { bool in
                    if bool {
                        strongSelf.createGroupStruct(groupName: groupName, completion: { result in
                            switch result {
                            case .success(let groupStruct):
                                DatabaseManager.shared.insertGroupStructure(groupStruct: groupStruct, groupID: groupID, completion: { bool in
                                    if bool {
                                        strongSelf.groupCreated()
                                    }
                                })
                            case .failure(_):
                                print("Could not createGroupStruct")
                                return
                            }
                        })
                    }
                })
            case .failure(_):
                print("createdGroups not properly init")
                return
            }
        })
        /*let userEmail = email
        var newArray = [String]()
        var position = Int()
        var keepInserting = true
        var shouldLoop = true
        //var aSyncBool = false
        // Check to see if the user has any rooms free
        // Come back to this later and see if you can clean it up
        DatabaseManager.shared.getCreatedGroups(with: email, completion: { [weak self] result in
            switch result {
            case .success(let data):
                var x = 0
                var isFull = true
                for name in data {
                    newArray.append(name)
                    if name == "" && x <= 2 && keepInserting {
                        newArray[x] = groupName
                        isFull = false
                        keepInserting = false
                        if x < 2 {
                            position = x
                        }
                    }
                    x += 1
                    if x >= 2 {
                        shouldLoop = false
                    }
                }
                if shouldLoop {
                    while position < 2 {
                        newArray.append("")
                        position += 1
                    }
                }
                if isFull == true {
                    // add uialert
                    self?.maxRoomsCreated()
                    print("no space to create room")
                    return
                }
                else {
                    guard newArray != nil else {
                        return
                    }
                    DatabaseManager.shared.createGroup(array: newArray, email: userEmail, completion: { [weak self] bool in
                        if bool {
                            guard let strongSelf = self else {
                                return
                            }
                            // Add group to the array
                            //let vc = HomeScreen()
                            //vc.data.append(HomeScreenViewModel(viewModelType: .group, title: groupName, handler: nil))
                            
                            // Add group to the array
                            /*HomeScreen().data.append(HomeScreenViewModel(viewModelType: .group,
                                                                         title: groupName,
                                                                         handler: nil))*/
                            // Push group VC
                            
                            // Create groupID and insert it into user branch
                            let groupID = DatabaseManager.shared.createGroupID(groupName: groupName, email: userEmail)
                            DatabaseManager.shared.insertGroupID(email: userEmail, groupID: groupID, groupName: groupName, completion: { bool in
                                if bool {
                                    // Insert the group into the collection of groups
                                    strongSelf.createGroupStruct(groupName: groupName, completion: { result in
                                        switch result {
                                        case .success(let groupStruct):
                                            DatabaseManager.shared.insertGroupStructure(groupStruct: groupStruct, groupID: groupID, completion: { bool in
                                                if bool {
                                                    print("Successfully added group structure")
                                                    self?.navigationController?.popViewController(animated: true)
                                                }
                                                else {
                                                    DatabaseManager.shared.deleteCreatedGroup(email: strongSelf.email, groupName: groupName, completion: { bool in})
                                                    DatabaseManager.shared.deleteGroupID(email: strongSelf.email, row: x - 1, completion: { bool in})
                                                    print("Could not insert groupStructure")
                                                }
                                            })
                                        case .failure(let error):
                                            print("Could not create groupStruct: \(error)")
                                        }
                                    })
                                    return
                                }
                                else {
                                    print("Error insterting into database")
                                    return
                                }
                            })
                            //self?.navigationController?.popViewController(animated: true)
                            //strongSelf.successfullyAddedGroup()
                            //let vc = GroupViewController()
                            
                            
                            
                            
                        }
                        else {
                            // failed to insert
                            print("Could not create group")
                            return
                        }
                    })
                }
            case .failure(_):
                return
            }
            
        })*/
    }
    
    @objc private func joinButtonTapped() {
        guard let groupID = joinGroupField.text,
              !groupID.isEmpty else {
            joinGroupFieldEmpty()
            return
        }
        
        DatabaseManager.shared.insertIntoGroup(groupID: groupID, memberName: memberName, email: email, completion: { [weak self] string in
            let memberExists = "memberExists"
            let success = "succcess"

            guard let strongSelf = self else {
                return
            }
            
            if string == success {
                strongSelf.joinedGroup()
            }
            else if string == memberExists {
                strongSelf.userExistsInGroup()
            }
            else {
                strongSelf.couldNotJoinGroup()
            }
        })
    }
}



// MARK: Extensions
extension CreateGroupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
