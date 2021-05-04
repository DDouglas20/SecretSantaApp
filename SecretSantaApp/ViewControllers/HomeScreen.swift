//
//  ViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import UIKit
import FirebaseAuth

class HomeScreen: UIViewController {
    
    var data = [HomeScreenViewModel]()
    
    var info = [HomeScreenViewModel]()
    
    private let tableView: UITableView  = {
        
        let tableView = UITableView()
        tableView.register(HomeScreenTableViewCell.self,
                           forCellReuseIdentifier: HomeScreenTableViewCell.identifier)
        
        return tableView
    }()
    
    private var userName: String = {
        var username = String()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        DatabaseManager.shared.getName(with: email, completion: { result in
            switch result {
            case .success(let data):
                guard let userData = data as? [String: Any],
                      let name = userData["name"] as? String else {
                        print("data was empty")
                        return
                }
                username = name 
                //print("This is name: \(name)")
            case .failure(let error):
                print("Failed to get user's name: \(error)")
            }
        })
        
        return username
    }()
    
    private var welcomeLabel: UILabel {
        let label = UILabel()
        label.text = "Welcome " + userName
        
        return label
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Screen"
        let titleAttribute = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        // View Appearance
        self.tableView.backgroundColor = .black
        self.tableView.separatorColor = .white
        navigationItem.largeTitleDisplayMode = .always
        
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
        data.append(HomeScreenViewModel(viewModelType: .section,
                                        title: "Your groups: ",
                                        handler: nil))
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        /*do {
           try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("already logged out")
        }*/
    }
    
    // MARK: Home Screen Functions

    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func tapCreateRoom() {
        
    }
    
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("This is count: \(data.count)")
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenTableViewCell.identifier, for: indexPath) as! HomeScreenTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    
}

