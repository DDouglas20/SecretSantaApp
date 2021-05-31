//
//  GroupViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/8/21.
//

import UIKit

class GroupViewController: UIViewController {
    
    private var memberName = CacheManager.getNameFromCache()
    
    private var memberEmail = CacheManager.getEmailFromCache()
    
    private var isCreator = Bool()
    
    private var groupID = String()
    
    private var groupName = String()
    
    private var groupMembers = [String]()
    
    private var groupPairs = [String: String]()
    
    private var memberGiftee = String()
    
    private var memberLoG = [Any]()
    
    private var gifteeLoG = [Any]()
    
    private var giftingScreen: UIView = {
        let view = UIView()
        view.isHidden = true
        
        return view
    }()
    
    private var rollScreen: UIView = {
       let view = UIView()
        view.isHidden = true
        
        return view
    }()
    
    private var viewTransition: UIView = {
       let view = UIView()
        
        return view
    }()
    
    private var memberScreen: UIView = {
       let view = UIView()
        view.isHidden = true
        
        return view
    }()
    
    
    
    private let pairButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        
        return button
    }()
    
    private let noCurrentPairsLabel: UILabel = {
       let label = UILabel()
        label.text = "Click the Image to get Started"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let waitingForGroupLeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for Group Leader to Start"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let pending = UIImage()
    
    private let complete = UIImage()
    
    private let userImage = UIImage()
    
    private let tableView: UITableView = {
       let table = UITableView()
        
        return table
    }()

    //MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update Variables
        getGroupMembers(completion: { bool in})
        

        // Add Bar Button Items
        let UIBarButton1: UIBarButtonItem = {
            let barButton = UIBarButtonItem(image: UIImage(systemName: "person.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(viewMembers))
            barButton.tintColor = .black
            return barButton
        }()
        let UIBarButton2: UIBarButtonItem = {
            let barButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(createGifts))
            barButton.tintColor = .black
            return barButton
        }()
        let UIBarButton3: UIBarButtonItem = {
           let button = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(changeEndDate))
            button.tintColor = .black
            return button
        }()
        let UIBarButton4: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(viewGifts))
            button.tintColor = .black
            return button
        }()
        navigationItem.rightBarButtonItems = [UIBarButton1, UIBarButton2, UIBarButton3, UIBarButton4]
        
        // Buttons
        pairButton.addTarget(self, action: #selector(beginPairing), for: .touchUpInside)
        
    
        // Add subviews
        view.addSubview(rollScreen)
        view.addSubview(giftingScreen)
        view.addSubview(memberScreen)
        rollScreen.addSubview(pairButton)
        rollScreen.addSubview(noCurrentPairsLabel)
        memberScreen.addSubview(waitingForGroupLeaderLabel)
        
        // Display Views
        displayPairs()
        
        // Data functions
        getSelfGifts(groupID: groupID, memberName: memberName)
        getGroupName()
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        if isCreator{
            rollScreen.frame = view.bounds
            
            pairButton.frame = CGRect(x: view.width/4, y: 250, width: view.width/2, height: view.height/4)
            
            noCurrentPairsLabel.frame = CGRect(x: 45, y: 100, width: view.width - 100, height: view.height/4)
        }
        
        if !isCreator {
            memberScreen.frame = view.bounds
            
            waitingForGroupLeaderLabel.frame = CGRect(x: 45, y: 100, width: view.width - 100, height: view.height/4)
        }
        
    }
    
    //MARK: Initializer
    init(email: String, id: String, isCreator: Bool) {
        self.groupID = id
        self.isCreator = isCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    private func getGroupName() {
        DatabaseManager.shared.getGroupName(groupID: groupID, completion: { [weak self] result in
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
    
    private func getGroupMembers(completion: @escaping (Bool) -> Void) {
        // Change this function to observe!!!!!
        DatabaseManager.shared.getGroupMembers(groupID: groupID, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let string):
                strongSelf.groupMembers = string
                completion(true)
            case .failure(let error):
                print("Could not get group members: \(error)")
                completion(false)
            }
        })
    }
    
    private func displayPairs() {
        DatabaseManager.shared.getPairs(groupID: groupID, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let dictionaryArr):
                strongSelf.giftingScreen.isHidden = false
                strongSelf.groupPairs = dictionaryArr
            case .failure(let error):
                print("No pairs exist: \(error)")
                strongSelf.rollScreen.isHidden = false
                strongSelf.memberScreen.isHidden = false
                
            }
        })
    }
    
    private func getSelfGifts(groupID: String, memberName: String) {
        let name = self.memberName
        DatabaseManager.shared.getListofGifts(groupID: groupID, memberName: name, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let gifts):
                strongSelf.memberLoG =  gifts
            case .failure(let error):
                print("Could not get gifts")
            }
        })
    }
    
    @objc private func beginPairing() {
        if groupMembers.count < 3 {
            notEnoughUsers()
            return
        }
        DatabaseManager.shared.createPairs(groupID: groupID, members: groupMembers, completion: { bool in
            if bool {
                // Start UI transitions
            }
        })
    }
    
    @objc private func viewMembers() {
        
        let popupVC = MembersViewController(members: groupMembers, groupID: groupID, groupName: groupName, isCreator: isCreator)
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    
    }
    
    @objc private func viewGifts() {
        let vc = MemberGiftsViewController(memberGifts: memberLoG, groupID: groupID)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .popover
        present(navVC, animated: true, completion: nil)
    }
    
    @objc private func createGifts() {
        let vc = AddGiftViewController(groupID: groupID, memberName: memberName, items: memberLoG)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func changeEndDate() {
        let vc = DateViewController(isCreator: isCreator)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }

}


//MARK: Extensions
extension GroupViewController: UIGestureRecognizerDelegate {
    
}


