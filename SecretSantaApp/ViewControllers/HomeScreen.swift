//
//  ViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import UIKit
import FirebaseAuth

class HomeScreen: UIViewController {
    
    // MARK: Variable Declaration
    private let userEmail = CacheManager.getEmailFromCache()
    
    private var indexPathName = String()
    
    private var shouldAppendAtEnd = true
    
    private var data = [HomeScreenViewModel]()
    
    private var collectedFirebaseArray = [String: String]()
    
    private var userGroups = [String: String]()
    
    private var isCreator = Bool()
    
    var userName = String()
    
    private let tableView: UITableView  = {
        
        let tableView = UITableView()
        tableView.register(HomeScreenTableViewCell.self,
                           forCellReuseIdentifier: HomeScreenTableViewCell.identifier)
        
        return tableView
    }()
    
    
    /*private var welcomeLabel: String {
        var label = String()
        label = "Welcome " + userName
        
        return label
    }*/
    
    // MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        // View Appearance
        self.tableView.backgroundColor = .black
        self.tableView.separatorColor = .white
        //navigationItem.largeTitleDisplayMode = .always

        
        // Nav Bar Items
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapCreateRoom))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        // Subviews
        view.addSubview(tableView)
        initTableView()
        
        // Table View items
        /*data.append(HomeScreenViewModel(viewModelType: .section,
                                        title: "Your Groups: ",
                                        handler: nil))*/
        /*showUserGroups(email: userEmail, completion: { [weak self] bool in
            
            if bool == true {
                self?.data.append(HomeScreenViewModel(viewModelType: .section,
                                                title: "Joined Groups: ",
                                                handler: nil))
            }
        })*/
        updateTableView()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        tableView.reloadData()
    }
    
    // MARK: Home Screen Functions
    private func getUserName(completion: @escaping (Result<String, Error>) -> Void) {
        let email = UserDefaults.standard.value(forKey: "email") as! String
        DatabaseManager.shared.getName(with: email, completion: { [weak self] result in
            switch result {
            case .success(let data):
                guard let userData = data as? String else {
                        print("data was empty")
                        return
                }
                let name = userData
                UserDefaults.standard.setValue(name, forKey: "name")
                completion(.success(name))
            case .failure(let error):
                print("Failed to get user's name: \(error)")
                completion(.failure(error))
            }
        })
    }

    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        
    }
    
    public func showUserGroups(email: String, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.getCreatedGroups(with: email, completion: { [weak self] result in
            switch result {
            case .success(let dictionary):
                let userData = dictionary
                for (group) in userData {
                    if group != "" {
                        self?.data.append(HomeScreenViewModel(viewModelType: .group,
                                                              title: group,
                                                              handler: nil))
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
            
        })
        
    }
    
    @objc private func tapCreateRoom() {
        let vc = CreateGroupViewController()
        vc.title = "Create Group"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func updateTableView() {
        DatabaseManager.shared.listenForGroupChanges(email: userEmail, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            self?.data = [HomeScreenViewModel]()
            self?.data.append(HomeScreenViewModel(viewModelType: .section, title: "Your Groups: ", handler: nil))
            switch result {
            case .success(let array):
                for group in array {
                    if group != "" {
                        self?.data.append(HomeScreenViewModel(viewModelType: .group,
                                                              title: group,
                                                              handler: nil))
                    }
                }
                self?.data.append(HomeScreenViewModel(viewModelType: .section, title: "Joined Groups: ", handler: nil))
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Could not get values: \(error)")
                return
            }
        })
    }
    
    
    // MARK: Table View Creation
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    private func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("Could not get user email")
            return nil
        }
        let pfp = email + "_profile_picture.png"
        let filepath = "images/" + pfp
        
        // Create the table header
        let headerView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.view.width,
                                               height: 300))
        headerView.backgroundColor = .black
        
        // Create the welcome label
        var headerLabel = UILabel(frame: CGRect(x: (headerView.width - 278),
                                                y: 50,
                                                width: headerView.width,
                                                height: 75))
        //print(userName)
        getUserName(completion: { [weak self] result in
            switch result {
            case .success(let name):
                headerLabel.text = "Welcome " + name
                self?.tableView.reloadData()
                return
            case .failure(let error):
                print("Could not find user")
                return
            }
            
        })
        headerLabel.textColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 30)
        
        
        // Create the user's profile picture
        let headerImage = UIImageView(frame: CGRect(x: (headerView.width - 150)/2,
                                                    y: 125,
                                                    width: 150,
                                                    height: 150))
        headerImage.contentMode = .scaleAspectFill
        headerImage.layer.borderColor = UIColor.white.cgColor
        headerImage.layer.borderWidth = 3
        headerImage.layer.masksToBounds = true
        headerImage.layer.cornerRadius = headerImage.width/2
        headerImage.image = UIImage(systemName: "person.circle.fill")
        headerImage.tintColor = .white
        
        // add the subviews
        headerView.addSubview(headerImage)
        headerView.addSubview(headerLabel)
        
        
        return headerView
    }
    
}

// MARK: Table View Functions
extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenTableViewCell.identifier, for: indexPath) as! HomeScreenTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.row].viewModelType != .section {
            tableView.deselectRow(at: indexPath, animated: true)
            indexPathName = data[indexPath.row].title
            data[indexPath.row].handler?()
            
            // Check if it's a created group or joined group
            var increment = 0
            var joinedGroupsRow = 1
            for title in data {
                if title.title == "Joined Groups: " {
                    joinedGroupsRow = increment
                }
                increment += 1
            }
            if indexPath.row > joinedGroupsRow {
                isCreator = false
                // Get the groupID from database. This person is not group leader
                // databse.child(email/joinedGroups)
            }
            else { // This is a created group. Get the info
                isCreator = true
                // Get group ID
                let index = indexPath.row - 1
                DatabaseManager.shared.getCreatedGroupsID(email: userEmail, row: index, completion: { [weak self] result in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let groupID):
                        // Push vc with groupID
                        let vc = GroupViewController(email: strongSelf.userEmail, id: groupID, isCreator: strongSelf.isCreator)
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        print("Could not get createdGroupsID: \(error)")
                        return
                    }
                })
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if data[indexPath.row].viewModelType != .section {
            return .delete
        }
        return .none
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete from database first
            // If data cannot be deleted, push error instead
            let groupName = data[indexPath.row].title
            DatabaseManager.shared.deleteGroup(email: userEmail, groupName: groupName, completion: { [weak self] bool in
                guard let strongSelf = self else {
                    return
                }
                if bool {
                    tableView.beginUpdates()
                    self?.data.remove(at: indexPath.row)
                    DatabaseManager.shared.deleteGroupID(email: strongSelf.userEmail, row: indexPath.row, completion: { bool in
                        if !bool {
                            self?.couldNotDeleteGroup()
                        }
                    })
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                }
                else {
                    self?.couldNotDeleteGroup()
                }
            })
            
            
            
        }
    }*/
    
}

