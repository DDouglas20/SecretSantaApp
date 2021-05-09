//
//  ProfileViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/3/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    private var tableViewData = [SettingsViewModel]()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(SettingsTableViewCell.self,
                       forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        // TableView Appearance
        self.tableView.backgroundColor = .black
        self.tableView.separatorColor = .white
        
        // Init tableView
        initTableView()
        
        // addSubviews
        view.addSubview(tableView)
        
        // Table View Data
        tableViewData.append(SettingsViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            self?.removeDataFromCache()
            self?.logOut()
        }))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // MARK: Functions
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func removeDataFromCache() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach( { key in
            defaults.removeObject(forKey: key)
        })
    }
    

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = tableViewData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewData[indexPath.row].handler?()
    }
    
}
