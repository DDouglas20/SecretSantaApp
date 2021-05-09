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
    @objc func createButtonTapped() {
        // unwrap
        guard let groupName = groupNameField.text,
              !groupName.isEmpty else {
                return
        }
        let userEmail = email
        var newArray = [String]()
        var position = Int()
        // Check to see if the user has any rooms free
        DatabaseManager.shared.getCreatedGroups(with: email, completion: { [weak self] result in
            switch result {
            case .success(let data):
                var x = 0
                var isFull = true
                for name in data {
                    print("this is name: \(name)")
                    newArray.append(name)
                    if name == "" {
                        newArray[x] = groupName
                        isFull = false
                        if x < 2 {
                            position = x
                        }
                        break
                    }
                    x += 1
                }
                print(position)
                while position < 2 {
                    newArray.append("")
                    position += 1
                }
                if isFull {
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
                            // Push group VC
                            self?.navigationController?.popToRootViewController(animated: true)
                            let vc = GroupViewController()
                            let navVC = UINavigationController(rootViewController: vc)
                            self?.present(navVC, animated: true)
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
