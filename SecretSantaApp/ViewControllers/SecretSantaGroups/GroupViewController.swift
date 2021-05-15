//
//  GroupViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/8/21.
//

import UIKit

class GroupViewController: UIViewController {
    
    private var isCreator = Bool()
    
    private var groupId = String()
    
    private var groupName = String()
    
    private var groupMembers = [String]()
    
    private let dice = UIImage()
    
    private let pending = UIImage()
    
    private let complete = UIImage()
    
    private let userImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Subviews
    }
    
    init(email: String, id: String, isCreator: Bool) {
        self.groupId = id
        self.isCreator = isCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    private func getGroupName() {
        DatabaseManager.shared.getGroupName(groupID: groupId, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let groupName):
                // Pass back group name and refresh table header
                strongSelf.groupName = groupName
            case .failure(let error):
                print("Could not fetch group Name: \(error)")
                return
            }
        })
    }

}
