//
//  AddGiftViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/22/21.
//

import UIKit

class AddGiftViewController: UIViewController {
    //MARK: Variables and initializers
    
    private let giftAddedLabel: UILabel = {
       let label = UILabel()
        label.text = "Gift Succesfully Added"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        label.isHidden = true
        
        return label
    }()
    
    private var memberItems = [Any]()
    
    private var groupID = String()
    
    private var memberName = String()
    
    private let addGiftLabel: UILabel = {
       let label = UILabel()
        label.text = "Type An Item or Paste a Link"
        label.font = .systemFont(ofSize: 25)
        label.textColor = .white
        
        return label
    }()
    
    private let addGiftTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.white.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        
        
        return textField
    }()
    
    private let addButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    init(groupID: String, memberName: String, items: [Any]) {
        self.groupID = groupID
        self.memberName = memberName
        self.memberItems = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Add Subviews
        view.addSubview(addGiftTextField)
        view.addSubview(addGiftLabel)
        view.addSubview(addButton)
        view.addSubview(giftAddedLabel)
        
        // Button functions
        addButton.addTarget(self, action: #selector(appendToList), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addGiftLabel.frame = CGRect(x: view.width/10, y: view.height/8, width: view.width, height: view.height/6)
        addGiftTextField.frame = CGRect(x: view.width/10 - 15, y: addGiftLabel.bottom - 10, width: view.width - 40, height: view.height/14)
        addButton.frame = CGRect(x: view.width/4, y: addGiftTextField.bottom + 10, width: view.width/2, height: view.height/14)
        giftAddedLabel.frame = CGRect(x: view.width/6, y: addButton.bottom + 20, width: view.width, height: view.height/14)
    }
    
    //MARK: Functions
    @objc private func appendToList() {
        
        guard let item = addGiftTextField.text,
              !item.isEmpty else {
                return
              }
        
        memberItems.append(item)
        
        DatabaseManager.shared.appendGift(groupID: groupID, items: memberItems, memberName: memberName, completion: { [weak self] bool in
            guard let strongSelf = self else {
                return
            }
            
            if bool {
                DispatchQueue.main.async {
                    strongSelf.giftAddedLabel.isHidden = false
                    let seconds = 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        strongSelf.giftAddedLabel.isHidden = true
                    }
                }
                
            }
            else {
                strongSelf.couldNotAddItem()
            }
        })
    }



}
