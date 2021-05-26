//
//  MemberListViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/22/21.
//

import UIKit


class MemberGiftsViewController: UIViewController {
    //MARK: Variables and Init
    
    private var memberLog = [Any]()
    
    private var memberName = UserDefaults.standard.value(forKey: "name") as? String ?? ""
    
    private var groupID = String()
    
    private let listTableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        return table
    }()
    
    init(memberGifts: [Any], groupID: String) {
        self.memberLog = memberGifts
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bar Button Items
        let UIBarButtonItem1: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
            button.tintColor = .red
            
            return button
        }()
        // Add Subviews
        view.addSubview(listTableView)
        navigationItem.leftBarButtonItem = UIBarButtonItem1
        
        // Init tableView
        listTableView.backgroundColor = .black
        listTableView.separatorColor = .white
        initTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        listTableView.frame = view.bounds
    }

    //MARK: Functions
    @objc private func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func initTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
}

extension MemberGiftsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = memberLog[indexPath.row] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if editingStyle == .delete {
            DatabaseManager.shared.deleteGift(groupID: groupID, memberName: memberName, arrIndex: index, completion: { [weak self] bool in
                guard let strongSelf = self else {
                    return
                }
                
                if bool {
                    tableView.beginUpdates()
                    strongSelf.memberLog.remove(at: index)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                }
                else {
                    strongSelf.couldNotDeleteItem()
                }
            })
        }
    }
    
    
}
