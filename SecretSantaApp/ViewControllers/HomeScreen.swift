//
//  ViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import UIKit
import FirebaseAuth

class HomeScreen: UIViewController {
    
    private let tableView: UITableView  = {
        let tableview = UITableView()
        
        return tableview
    }()
    
    private var userName: String = {
        var username = String()
        let email = UserDefaults.standard.value(forKey: "email") as! String
        DatabaseManager.shared.getName(with: email, completion: { result in
            switch result {
            case .success(let name):
                username = name as! String
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
        
        // View Appearance
        view.backgroundColor = .black
        
        // Subviews
        
        
        
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

    private func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        
    }
    
}


